import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

/// iPhone 14 / common design target
const Size kMobileDesignSize = Size(390, 844);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const BlackJackTrackingApp());
}

class BlackJackTrackingApp extends StatelessWidget {
  const BlackJackTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black Jack Tracking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      builder: (context, child) {
        final app = child ?? const SizedBox.shrink();
        if (!kIsWeb) return app;
        return _MobilePhoneFrame(child: app);
      },
      home: const SplashScreen(),
    );
  }
}

/// Centers the Flutter UI in a 390×844 phone shell on web.
class _MobilePhoneFrame extends StatelessWidget {
  final Widget child;

  const _MobilePhoneFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF070707),
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: kMobileDesignSize.width + 24,
            height: kMobileDesignSize.height + 24,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFF333333), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: kMobileDesignSize.width,
                height: kMobileDesignSize.height,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: kMobileDesignSize,
                    padding: const EdgeInsets.only(top: 12, bottom: 16),
                    devicePixelRatio: 2,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
