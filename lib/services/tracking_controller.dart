import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import 'weather_service.dart';

class TrackingController extends ChangeNotifier {
  TrackingController() {
    _bootstrap();
  }

  final _weatherService = WeatherService();
  Timer? _liveTimer;

  late CustomerTrackingSession session = CustomerTrackingSession(
    trackingCode: 'BJ-RSK-88421',
    customerName: 'Sarah Mitchell',
    email: 'sarah.mitchell@email.com',
    phone: '+1 (250) 555-0198',
    propertyAddress: '214 Mackenzie Ave, Revelstoke, BC',
    companyName: 'Black Jack Tracking',
    operatorName: 'Jake Morrison',
    vehicle: 'Plow Unit #7',
    propertyLat: 50.9989,
    propertyLng: -118.1972,
    operatorStartLat: 50.9920,
    operatorStartLng: -118.1850,
    stopsAway: 5,
    proximityAlertSent: true,
    startedAt: DateTime.now().subtract(const Duration(minutes: 18)),
    activityLog: [
      'Tracking link opened',
      'Operator assigned: Jake Morrison',
      'Proximity alert: 5 stops away',
    ],
  );

  NotificationPrefs prefs = NotificationPrefs();
  DailyWeather? weather;
  bool weatherLoading = true;
  String? weatherError;
  bool ready = false;

  Future<void> _bootstrap() async {
    await _loadPrefs();
    ready = true;
    notifyListeners();
    unawaited(refreshWeather());
    if (session.phase == ServicePhase.tracking && session.liveUpdatesEnabled) {
      startLiveTracking();
    }
  }

  Future<void> _loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    prefs = NotificationPrefs(
      smsAlerts: sp.getBool('smsAlerts') ?? true,
      emailAlerts: sp.getBool('emailAlerts') ?? true,
      proximityAlerts: sp.getBool('proximityAlerts') ?? true,
    );
    final savedRating = sp.getInt('lastRating');
    final savedPhase = sp.getString('phase');
    if (savedPhase == 'rated' && savedRating != null) {
      session.phase = ServicePhase.rated;
      session.rating = savedRating;
      session.feedback = sp.getString('feedback');
      session.finishedAt = DateTime.tryParse(sp.getString('finishedAt') ?? '');
      session.stopsAway = 0;
    } else if (savedPhase == 'completed') {
      session.phase = ServicePhase.completed;
      session.finishedAt = DateTime.tryParse(sp.getString('finishedAt') ?? '') ??
          DateTime.now();
      session.stopsAway = 0;
    }
  }

  Future<void> _persist() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('smsAlerts', prefs.smsAlerts);
    await sp.setBool('emailAlerts', prefs.emailAlerts);
    await sp.setBool('proximityAlerts', prefs.proximityAlerts);
    await sp.setString('phase', session.phase.name);
    if (session.finishedAt != null) {
      await sp.setString('finishedAt', session.finishedAt!.toIso8601String());
    }
    if (session.rating != null) {
      await sp.setInt('lastRating', session.rating!);
    }
    if (session.feedback != null) {
      await sp.setString('feedback', session.feedback!);
    }
  }

  Future<void> refreshWeather() async {
    weatherLoading = true;
    weatherError = null;
    notifyListeners();
    try {
      weather = await _weatherService.fetchDaily();
    } catch (_) {
      weather = WeatherService.fallback();
      weatherError = 'Showing offline estimate';
    } finally {
      weatherLoading = false;
      notifyListeners();
    }
  }

  void startLiveTracking() {
    _liveTimer?.cancel();
    session.liveUpdatesEnabled = true;
    _liveTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (session.phase != ServicePhase.tracking) {
        _liveTimer?.cancel();
        return;
      }
      advanceOperator();
    });
    _log('Live GPS updates enabled');
    notifyListeners();
  }

  void pauseLiveTracking() {
    _liveTimer?.cancel();
    session.liveUpdatesEnabled = false;
    _log('Live GPS updates paused');
    notifyListeners();
  }

  void advanceOperator() {
    if (session.phase != ServicePhase.tracking) return;

    if (session.stopsAway > 1) {
      session.stopsAway -= 1;
      if (session.stopsAway == 5 && prefs.proximityAlerts) {
        session.proximityAlertSent = true;
        _log('Proximity alert sent: 5 stops away');
      } else {
        _log('Operator moved closer · ${session.stopsAway} stops away');
      }
    } else {
      completeService();
      return;
    }
    notifyListeners();
  }

  void completeService() {
    _liveTimer?.cancel();
    session.phase = ServicePhase.completed;
    session.stopsAway = 0;
    session.finishedAt = DateTime.now();
    session.liveUpdatesEnabled = false;
    _log(
      'Operator finished property at ${_formatTime(session.finishedAt!)}',
    );
    _persist();
    notifyListeners();
  }

  Future<void> submitRating(int stars, String feedback) async {
    session.rating = stars;
    session.feedback = feedback.trim().isEmpty ? null : feedback.trim();
    session.phase = ServicePhase.rated;
    if (stars == 5) {
      _log('5★ rating submitted · Google Reviews offered');
    } else {
      _log('$stars★ rating sent to admin quality dashboard');
    }
    await _persist();
    notifyListeners();
  }

  Future<bool> openGoogleReviews() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Revelstoke+BC+snow+removal+reviews',
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> updatePrefs({
    bool? sms,
    bool? email,
    bool? proximity,
  }) async {
    if (sms != null) prefs.smsAlerts = sms;
    if (email != null) prefs.emailAlerts = email;
    if (proximity != null) prefs.proximityAlerts = proximity;
    await _persist();
    notifyListeners();
  }

  Future<void> resetTracking() async {
    _liveTimer?.cancel();
    final sp = await SharedPreferences.getInstance();
    await sp.remove('phase');
    await sp.remove('finishedAt');
    await sp.remove('lastRating');
    await sp.remove('feedback');
    session.phase = ServicePhase.tracking;
    session.stopsAway = 5;
    session.proximityAlertSent = prefs.proximityAlerts;
    session.finishedAt = null;
    session.rating = null;
    session.feedback = null;
    session.startedAt = DateTime.now();
    session.activityLog = [
      'Tracking restarted',
      'Operator assigned: ${session.operatorName}',
      if (prefs.proximityAlerts) 'Proximity alerts enabled',
    ];
    startLiveTracking();
  }

  Future<void> logout() async {
    _liveTimer?.cancel();
    session.liveUpdatesEnabled = false;
    _log('Customer logged out of tracking session');
    notifyListeners();
  }

  void _log(String message) {
    final stamp = _formatTime(DateTime.now());
    session.activityLog.insert(0, '$stamp · $message');
    if (session.activityLog.length > 12) {
      session.activityLog = session.activityLog.take(12).toList();
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ap = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }
}
