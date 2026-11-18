import 'package:material_ui/material_ui.dart';
import '../../main.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_header.dart';
import 'profile_faq_screen.dart';
import 'profile_my_profile_screen.dart';
import 'profile_privacy_screen.dart';
import 'profile_settings_screen.dart';
import 'profile_terms_screen.dart';
import '../logged_out_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = TrackingScope.of(context).session;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          const Center(child: BrandHeader(logoHeight: 72)),
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.softTeal,
            child: Text(
              session.customerName
                  .split(' ')
                  .where((e) => e.isNotEmpty)
                  .map((e) => e[0])
                  .take(2)
                  .join()
                  .toUpperCase(),
              style: const TextStyle(
                color: AppColors.tealDim,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            session.customerName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            session.email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 22),
          _menuCard(
            context,
            items: [
              _MenuItem(
                icon: Icons.person_outline,
                title: 'My Profile',
                subtitle: 'Name, property, contact details',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfileMyProfileScreen(),
                  ),
                ),
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Notifications & tracking preferences',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfileSettingsScreen(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _menuCard(
            context,
            items: [
              _MenuItem(
                icon: Icons.description_outlined,
                title: 'Terms and Conditions',
                subtitle: 'Service agreement',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfileTermsScreen(),
                  ),
                ),
              ),
              _MenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'How we use your data',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfilePrivacyScreen(),
                  ),
                ),
              ),
              _MenuItem(
                icon: Icons.help_outline,
                title: 'FAQ',
                subtitle: 'Common questions',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileFaqScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _menuCard(
            context,
            items: [
              _MenuItem(
                icon: Icons.logout,
                title: 'Log out',
                subtitle: 'End this tracking session',
                danger: true,
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will leave this live tracking session. You can reopen your SMS/email link anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await TrackingScope.of(context).logout();
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoggedOutScreen()),
      (_) => false,
    );
  }

  Widget _menuCard(BuildContext context, {required List<_MenuItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              onTap: items[i].onTap,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: items[i].danger
                      ? AppColors.danger.withValues(alpha: 0.1)
                      : AppColors.softTeal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  items[i].icon,
                  color: items[i].danger ? AppColors.danger : AppColors.teal,
                ),
              ),
              title: Text(
                items[i].title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: items[i].danger ? AppColors.danger : null,
                ),
              ),
              subtitle: Text(
                items[i].subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: items[i].danger ? AppColors.danger : AppColors.charcoal,
              ),
            ),
            if (i < items.length - 1)
              const Divider(height: 1, color: AppColors.cardBorder),
          ],
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });
}
