import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';

class LiveMapCanvas extends StatelessWidget {
  final String operatorLabel;
  final String propertyLabel;
  final int stopsAway;
  final double progress;
  final bool completed;
  final double? height;
  final BorderRadius? borderRadius;

  const LiveMapCanvas({
    super.key,
    required this.operatorLabel,
    required this.propertyLabel,
    required this.stopsAway,
    required this.progress,
    this.completed = false,
    this.height = 300,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);
    final map = Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(completed: completed, progress: progress),
              ),
            ),
            Positioned(
              left: 36,
              top: 88,
              child: _pin(
                icon: Icons.home_filled,
                color: completed ? AppColors.success : AppColors.warning,
                label: propertyLabel,
              ),
            ),
            if (!completed)
              Positioned(
                left: 48 + (220 * (1 - progress)),
                top: 88 + (120 * (1 - progress)),
                child: _pin(
                  icon: Icons.local_shipping,
                  color: AppColors.teal,
                  label: operatorLabel,
                  glow: true,
                ),
              ),
            Positioned(
              left: 12,
              right: 12,
              top: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      completed ? Icons.check_circle : Icons.gps_fixed,
                      size: 16,
                      color: completed ? AppColors.success : AppColors.teal,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        completed
                            ? 'Service complete at your property'
                            : 'Operator is $stopsAway stops away · ${(progress * 100).round()}% of route',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: completed ? 1 : progress,
                  minHeight: 8,
                  backgroundColor: Colors.white,
                  color: completed ? AppColors.success : AppColors.teal,
                ),
              ),
            ),
          ],
    );

    return ClipRRect(
      borderRadius: radius,
      child: height == null
          ? SizedBox.expand(child: map)
          : SizedBox(height: height, width: double.infinity, child: map),
    );
  }

  Widget _pin({
    required IconData icon,
    required Color color,
    required String label,
    bool glow = false,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: glow
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(maxWidth: 140),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.45)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  final bool completed;
  final double progress;

  _MapPainter({required this.completed, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE8F6F3), Color(0xFFF4F8F7), Color(0xFFE3EEF2)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final grid = Paint()
      ..color = AppColors.teal.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final pathPaint = Paint()
      ..color = completed
          ? AppColors.success.withValues(alpha: 0.7)
          : AppColors.teal.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final start = Offset(size.width * 0.78, size.height * 0.72);
    final end = Offset(size.width * 0.22, size.height * 0.42);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.55,
        end.dx,
        end.dy,
      );
    canvas.drawPath(path, pathPaint);

    final ring = Paint()
      ..color = AppColors.teal.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(start, 34, ring);
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) =>
      oldDelegate.completed != completed || oldDelegate.progress != progress;
}
