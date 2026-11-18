import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';

class BrandHeader extends StatelessWidget {
  final double logoHeight;
  final bool compact;

  const BrandHeader({
    super.key,
    this.logoHeight = 120,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BLACK JACK',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'T R A C K I N G',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.4,
                  fontSize: 9,
                  color: AppColors.teal,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: logoHeight,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
