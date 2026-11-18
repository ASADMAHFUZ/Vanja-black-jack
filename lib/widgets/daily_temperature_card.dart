import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import '../main.dart';
import '../models/models.dart';
import '../services/tracking_controller.dart';
import '../theme/app_theme.dart';

class DailyTemperatureCard extends StatelessWidget {
  const DailyTemperatureCard({super.key});

  IconData _iconFor(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('snow')) return Icons.ac_unit;
    if (c.contains('rain') || c.contains('shower')) return Icons.umbrella;
    if (c.contains('cloud')) return Icons.cloud_outlined;
    if (c.contains('clear')) return Icons.wb_sunny_outlined;
    return Icons.thermostat;
  }

  @override
  Widget build(BuildContext context) {
    final controller = TrackingScope.of(context);
    final weather = controller.weather;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F7F5), Color(0xFFEFF4F8)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: controller.weatherLoading && weather == null
          ? const SizedBox(
              height: 84,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ),
            )
          : _content(controller, weather),
    );
  }

  Widget _content(TrackingController controller, DailyWeather? weather) {
    if (weather == null) {
      return Row(
        children: [
          const Expanded(child: Text('Unable to load temperature')),
          TextButton(
            onPressed: controller.refreshWeather,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    final dateLabel = DateFormat('EEEE, MMM d').format(weather.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Icon(
                _iconFor(weather.condition),
                color: AppColors.teal,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily temperature',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  Text(
                    '${weather.location} · $dateLabel',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${weather.currentC.round()}°',
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: AppColors.tealDim,
                height: 1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'C',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.tealDim,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Refresh weather',
              onPressed: controller.weatherLoading
                  ? null
                  : controller.refreshWeather,
              icon: controller.weatherLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh, color: AppColors.teal),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _chip(Icons.arrow_upward, 'High ${weather.highC.round()}°C'),
            const SizedBox(width: 8),
            _chip(Icons.arrow_downward, 'Low ${weather.lowC.round()}°C'),
            const SizedBox(width: 8),
            _chip(Icons.cloud_queue_outlined, weather.condition),
          ],
        ),
        if (weather.note != null) ...[
          const SizedBox(height: 10),
          Text(
            weather.note!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
        if (controller.weatherError != null) ...[
          const SizedBox(height: 6),
          Text(
            controller.weatherError!,
            style: const TextStyle(color: AppColors.warning, fontSize: 11),
          ),
        ] else if (weather.fromApi) ...[
          const SizedBox(height: 6),
          const Text(
            'Live Open-Meteo forecast',
            style: TextStyle(color: AppColors.charcoal, fontSize: 11),
          ),
        ],
      ],
    );
  }

  Widget _chip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.teal),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
