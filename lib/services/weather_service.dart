import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class WeatherService {
  /// Revelstoke, BC
  static const lat = 50.9981;
  static const lng = -118.1957;

  Future<DailyWeather> fetchDaily() async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat&longitude=$lng'
      '&current=temperature_2m,weather_code'
      '&daily=temperature_2m_max,temperature_2m_min,weather_code'
      '&timezone=America%2FVancouver'
      '&forecast_days=1',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      throw Exception('Weather request failed');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final current = data['current'] as Map<String, dynamic>;
    final daily = data['daily'] as Map<String, dynamic>;
    final code = (current['weather_code'] as num?)?.toInt() ?? 0;

    return DailyWeather(
      date: DateTime.now(),
      location: 'Revelstoke, BC',
      currentC: (current['temperature_2m'] as num).toDouble(),
      highC: ((daily['temperature_2m_max'] as List).first as num).toDouble(),
      lowC: ((daily['temperature_2m_min'] as List).first as num).toDouble(),
      condition: _conditionLabel(code),
      note: _noteFor(code),
      fromApi: true,
    );
  }

  static DailyWeather fallback() {
    return DailyWeather(
      date: DateTime.now(),
      location: 'Revelstoke, BC',
      currentC: -6,
      highC: -2,
      lowC: -11,
      condition: 'Snow',
      note: 'Offline weather estimate — reconnect for live readings.',
      fromApi: false,
    );
  }

  String _conditionLabel(int code) {
    if (code == 0) return 'Clear';
    if (code <= 3) return 'Cloudy';
    if (code <= 67) return 'Rain';
    if (code <= 77) return 'Snow';
    if (code <= 82) return 'Showers';
    if (code <= 86) return 'Snow showers';
    return 'Storm';
  }

  String _noteFor(int code) {
    if (code >= 71 && code <= 77) {
      return 'Snow conditions — plow crews are active in your area.';
    }
    if (code >= 61) {
      return 'Wet roads possible — operators may adjust route timing.';
    }
    return 'Live forecast for your service area.';
  }
}
