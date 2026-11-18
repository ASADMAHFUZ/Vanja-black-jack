import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'screens/splash_screen.dart';
import 'services/tracking_controller.dart';
import 'theme/app_theme.dart';

const Size kMobileDesignSize = Size(390, 844);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const BlackJackTrackingApp());
}

class BlackJackTrackingApp extends StatefulWidget {
  const BlackJackTrackingApp({super.key});

  @override
  State<BlackJackTrackingApp> createState() => _BlackJackTrackingAppState();
}

class _BlackJackTrackingAppState extends State<BlackJackTrackingApp> {
  late final TrackingController controller;

  @override
  void initState() {
    super.initState();
    controller = TrackingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TrackingScope(
      controller: controller,
      child: MaterialApp(
        title: 'Black Jack Tracking',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        builder: (context, child) {
          final app = child ?? const SizedBox.shrink();
          if (!kIsWeb) return app;
          return _MobilePhoneFrame(child: app);
        },
        home: const SplashScreen(),
      ),
    );
  }
}

class TrackingScope extends InheritedNotifier<TrackingController> {
  const TrackingScope({
    super.key,
    required TrackingController controller,
    required super.child,
  }) : super(notifier: controller);

  static TrackingController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TrackingScope>();
    assert(scope != null, 'TrackingScope not found');
    return scope!.notifier!;
  }
}

class _MobilePhoneFrame extends StatelessWidget {
  final Widget child;

  const _MobilePhoneFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8EEED),
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: kMobileDesignSize.width + 24,
            height: kMobileDesignSize.height + 24,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5F5),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFC9D5D3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.14),
                  blurRadius: 36,
                  spreadRadius: 1,
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
