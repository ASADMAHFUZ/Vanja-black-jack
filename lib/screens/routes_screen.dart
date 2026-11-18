import 'package:material_ui/material_ui.dart';
import '../data/demo_data.dart';
import '../theme/app_theme.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route List'),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Route optimized — saved ~18 min & fuel'),
                ),
              );
            },
            icon: const Icon(Icons.auto_awesome, color: AppColors.teal),
            label: const Text(
              'Optimize',
              style: TextStyle(color: AppColors.teal),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.timeline, color: AppColors.teal),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Optimized order based on distance, priority & weather',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...DemoData.jobs.asMap().entries.map((entry) {
            final i = entry.key;
            final job = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.teal.withValues(alpha: 0.2),
                          border: Border.all(color: AppColors.teal),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: AppColors.teal,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (i < DemoData.jobs.length - 1)
                        Container(
                          width: 2,
                          height: 80,
                          color: AppColors.cardBorder,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: JobCard(
                      job: job,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => JobDetailScreen(job: job),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
