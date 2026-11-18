enum ServicePhase { tracking, completed, rated }

class CustomerTrackingSession {
  final String trackingCode;
  final String customerName;
  final String email;
  final String phone;
  final String propertyAddress;
  final String companyName;
  final String operatorName;
  final String vehicle;
  final double propertyLat;
  final double propertyLng;
  final double operatorStartLat;
  final double operatorStartLng;
  int stopsAway;
  bool proximityAlertSent;
  bool liveUpdatesEnabled;
  ServicePhase phase;
  DateTime? startedAt;
  DateTime? finishedAt;
  int? rating;
  String? feedback;
  List<String> activityLog;

  CustomerTrackingSession({
    required this.trackingCode,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.propertyAddress,
    required this.companyName,
    required this.operatorName,
    required this.vehicle,
    required this.propertyLat,
    required this.propertyLng,
    required this.operatorStartLat,
    required this.operatorStartLng,
    required this.stopsAway,
    this.proximityAlertSent = false,
    this.liveUpdatesEnabled = true,
    this.phase = ServicePhase.tracking,
    this.startedAt,
    this.finishedAt,
    this.rating,
    this.feedback,
    List<String>? activityLog,
  }) : activityLog = activityLog ?? [];

  double get progress {
    const total = 8;
    final remaining = stopsAway.clamp(0, total);
    return ((total - remaining) / total).clamp(0.0, 1.0);
  }

  double get operatorLat =>
      operatorStartLat + (propertyLat - operatorStartLat) * progress;
  double get operatorLng =>
      operatorStartLng + (propertyLng - operatorStartLng) * progress;
}

class DailyWeather {
  final DateTime date;
  final String location;
  final double currentC;
  final double highC;
  final double lowC;
  final String condition;
  final String? note;
  final bool fromApi;

  const DailyWeather({
    required this.date,
    required this.location,
    required this.currentC,
    required this.highC,
    required this.lowC,
    required this.condition,
    this.note,
    this.fromApi = false,
  });
}

class NotificationPrefs {
  bool smsAlerts;
  bool emailAlerts;
  bool proximityAlerts;

  NotificationPrefs({
    this.smsAlerts = true,
    this.emailAlerts = true,
    this.proximityAlerts = true,
  });
}
