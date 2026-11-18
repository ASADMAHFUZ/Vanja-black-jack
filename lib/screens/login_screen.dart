import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_header.dart';
import 'shell_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController(text: 'marcus.chen');
  final _pinController = TextEditingController(text: '••••');
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ShellScreen()),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const BrandHeader(logoHeight: 140),
              const SizedBox(height: 12),
              const Text(
                'Sign in to start your shift',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 36),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Operator ID',
                  prefixIcon: Icon(Icons.badge_outlined, color: AppColors.teal),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pinController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.teal),
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.black,
                        ),
                      )
                    : const Text('Clock Into App'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Demo credentials prefilled — tap to continue',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.charcoal, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
