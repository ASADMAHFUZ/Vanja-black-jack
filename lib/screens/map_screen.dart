import 'package:material_ui/material_ui.dart';
import '../data/demo_data.dart';
import '../models/job.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Operations'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.4),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.gps_fixed, size: 14, color: AppColors.success),
                    SizedBox(width: 6),
                    Text(
                      'GPS Live',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0E1C1B), Color(0xFF111111), Color(0xFF0A1520)],
              ),
            ),
            child: CustomPaint(painter: _MapGridPainter()),
          ),
          ..._pins(context),
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.48,
            top: MediaQuery.sizeOf(context).height * 0.38,
            child: _crewPin(),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _siteSheet(),
          ),
        ],
      ),
    );
  }

  List<Widget> _pins(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final positions = [
      Offset(size.width * 0.22, size.height * 0.22),
      Offset(size.width * 0.68, size.height * 0.28),
      Offset(size.width * 0.35, size.height * 0.48),
      Offset(size.width * 0.72, size.height * 0.52),
    ];

    return List.generate(DemoData.jobs.length, (i) {
      final job = DemoData.jobs[i];
      final pos = positions[i];
      final color = switch (job.status) {
        JobStatus.completed => AppColors.success,
        JobStatus.inProgress || JobStatus.enRoute => AppColors.tealBright,
        JobStatus.pending => AppColors.warning,
      };
      return Positioned(
        left: pos.dx,
        top: pos.dy,
        child: Column(
          children: [
            Icon(Icons.location_on, color: color, size: 36),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.card.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.5)),
              ),
              child: Text(
                job.name.split(' ').first,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _crewPin() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.teal,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.teal.withValues(alpha: 0.55),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.local_shipping, color: AppColors.black, size: 20),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.teal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'You · Unit #12',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _siteSheet() {
    final next = DemoData.jobs.firstWhere(
      (j) => j.status != JobStatus.completed,
      orElse: () => DemoData.jobs.first,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Next stop',
            style: TextStyle(color: AppColors.teal, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            next.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          Text(
            next.address,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.fence, size: 16, color: AppColors.teal),
              const SizedBox(width: 6),
              const Text(
                'Inside geofence · auto check-in ready',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                next.eta,
                style: const TextStyle(
                  color: AppColors.tealBright,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.teal.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final ring = Paint()
      ..color = AppColors.teal.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.4),
      70,
      ring,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.4),
      110,
      ring..color = AppColors.teal.withValues(alpha: 0.1),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
