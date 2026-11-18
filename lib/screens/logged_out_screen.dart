import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_header.dart';
import 'customer/customer_shell_screen.dart';

class LoggedOutScreen extends StatelessWidget {
  const LoggedOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const BrandHeader(logoHeight: 120),
              const SizedBox(height: 20),
              const Text(
                'You are logged out',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your live tracking session has ended. Reopen your SMS/email link anytime to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const CustomerShellScreen(),
                      ),
                      (_) => false,
                    );
                  },
                  child: const Text('Open tracking again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
