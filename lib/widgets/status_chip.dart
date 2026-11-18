import 'package:material_ui/material_ui.dart';
import '../models/job.dart';
import '../theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final JobStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      JobStatus.pending => ('Pending', AppColors.warning),
      JobStatus.enRoute => ('En Route', AppColors.teal),
      JobStatus.inProgress => ('In Progress', AppColors.tealBright),
      JobStatus.completed => ('Completed', AppColors.success),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
