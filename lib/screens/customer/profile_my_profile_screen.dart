import 'package:material_ui/material_ui.dart';
import '../../main.dart';
import '../../theme/app_theme.dart';

class ProfileMyProfileScreen extends StatelessWidget {
  const ProfileMyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = TrackingScope.of(context).session;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card([
            _row(Icons.person_outline, 'Full name', session.customerName),
            _divider(),
            _row(Icons.mail_outline, 'Email', session.email),
            _divider(),
            _row(Icons.phone_outlined, 'Phone', session.phone),
            _divider(),
            _row(Icons.home_outlined, 'Property', session.propertyAddress),
            _divider(),
            _row(Icons.link, 'Tracking code', session.trackingCode),
            _divider(),
            _row(
              Icons.local_shipping_outlined,
              'Assigned operator',
              '${session.operatorName} · ${session.vehicle}',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() =>
      const Divider(color: AppColors.cardBorder, height: 24);

  Widget _row(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.teal, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.charcoal, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
