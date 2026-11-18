import 'package:material_ui/material_ui.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/google_map_panel.dart';

class CustomerMapScreen extends StatelessWidget {
  const CustomerMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TrackingScope.of(context);
    final session = controller.session;
    final completed = session.phase != ServicePhase.tracking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live mapping'),
        actions: [
          if (!completed)
            TextButton(
              onPressed: controller.advanceOperator,
              child: const Text(
                'Refresh',
                style: TextStyle(color: AppColors.teal),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: GoogleMapPanel(
                operatorLat: session.operatorLat,
                operatorLng: session.operatorLng,
                propertyLat: session.propertyLat,
                propertyLng: session.propertyLng,
                operatorLabel: session.operatorName,
                propertyLabel: 'Your property',
                stopsAway: session.stopsAway,
                progress: session.progress,
                completed: completed,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        completed ? Icons.check_circle : Icons.route,
                        color: completed ? AppColors.success : AppColors.teal,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          completed
                              ? 'Route finished'
                              : 'Google Map · ${session.stopsAway} stops away',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    session.propertyAddress,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session.operatorName} · ${session.vehicle}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  if (!completed) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: session.liveUpdatesEnabled
                            ? controller.pauseLiveTracking
                            : controller.startLiveTracking,
                        icon: Icon(
                          session.liveUpdatesEnabled
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        label: Text(
                          session.liveUpdatesEnabled
                              ? 'Pause live tracking'
                              : 'Resume live tracking',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
