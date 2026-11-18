import 'package:material_ui/material_ui.dart';
import '../../main.dart';
import '../../theme/app_theme.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TrackingScope.of(context);
    final prefs = controller.prefs;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Notification preferences',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.teal,
                  title: const Text('SMS tracking links'),
                  subtitle: const Text('Get the live map link by text'),
                  value: prefs.smsAlerts,
                  onChanged: (v) => controller.updatePrefs(sms: v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.teal,
                  title: const Text('Email updates'),
                  subtitle: const Text('Completion notices by email'),
                  value: prefs.emailAlerts,
                  onChanged: (v) => controller.updatePrefs(email: v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.teal,
                  title: const Text('Proximity alerts'),
                  subtitle: const Text('Notify when plow is 5 stops away'),
                  value: prefs.proximityAlerts,
                  onChanged: (v) => controller.updatePrefs(proximity: v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tracking',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              await controller.resetTracking();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Live tracking restarted'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Restart live tracking'),
          ),
        ],
      ),
    );
  }
}
