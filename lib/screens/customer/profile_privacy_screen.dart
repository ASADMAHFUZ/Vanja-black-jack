import 'package:material_ui/material_ui.dart';
import '../../theme/app_theme.dart';

class ProfilePrivacyScreen extends StatelessWidget {
  const ProfilePrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            'What we collect',
            'Property address, contact details used for SMS/email links, service timestamps, optional ratings/feedback, and temporary operator location during an active route.',
          ),
          _section(
            'How we use it',
            'Data is used only to dispatch crews, show live tracking, send proximity alerts, and improve service quality. We do not sell personal information.',
          ),
          _section(
            'Sharing',
            'Operational staff and assigned operators can see what they need for your service. Under-5★ feedback stays internal to admin quality review.',
          ),
          _section(
            'Retention',
            'Live tracking ends after completion. Preference settings may be stored on your device. Service records are kept as needed for contract operations.',
          ),
          _section(
            'Your choices',
            'You can turn SMS, email, and proximity alerts on/off in Settings, and log out of the tracking session at any time.',
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              body,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
