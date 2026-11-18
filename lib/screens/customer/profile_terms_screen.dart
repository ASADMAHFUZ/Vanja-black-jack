import 'package:material_ui/material_ui.dart';
import '../../theme/app_theme.dart';

class ProfileTermsScreen extends StatelessWidget {
  const ProfileTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms and Conditions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            '1. Service use',
            'Black Jack Tracking provides live snow-clearing status for contracted properties in Revelstoke, BC. This customer link is for operational tracking only and does not process payments or invoices.',
          ),
          _section(
            '2. Accurate information',
            'Customers are responsible for keeping contact details current so SMS/email tracking links and proximity alerts can be delivered.',
          ),
          _section(
            '3. Live location',
            'During an active snow event you may see your assigned operator’s approximate location and route progress. Location visibility ends when service is complete.',
          ),
          _section(
            '4. Ratings',
            'Star ratings help quality control. Ratings under 5 stars remain internal. 5-star reviews may be invited to Google Reviews.',
          ),
          _section(
            '5. Acceptance',
            'Opening and using the tracking link means you agree to these terms for the current service event.',
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
