import 'package:material_ui/material_ui.dart';
import '../data/demo_data.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_header.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Operator Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: BrandHeader(logoHeight: 100)),
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Text(
                  DemoData.operatorName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DemoData.crewId} · ${DemoData.vehicle}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _tile(Icons.assignment_turned_in, 'Jobs completed today', '1'),
          _tile(Icons.timer_outlined, 'Hours on shift', '—'),
          _tile(Icons.ac_unit, 'Material logged', '${DemoData.materialLogs.length} entries'),
          _tile(Icons.phone_in_talk, 'Dispatch', '(612) 555-0140'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App scope (MVP)',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Clock-in · Live routes · GPS/geofence · Photo proof · Material logging',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String trailing) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.teal),
      title: Text(title),
      trailing: Text(
        trailing,
        style: const TextStyle(
          color: AppColors.teal,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
