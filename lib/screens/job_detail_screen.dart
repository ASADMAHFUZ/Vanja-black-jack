import 'package:material_ui/material_ui.dart';
import '../data/demo_data.dart';
import '../models/job.dart';
import '../theme/app_theme.dart';
import '../widgets/status_chip.dart';

class JobDetailScreen extends StatefulWidget {
  final JobSite job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late JobSite _job;
  bool _beforePhoto = false;
  bool _afterPhoto = false;
  bool _gpsVerified = false;

  @override
  void initState() {
    super.initState();
    _job = widget.job;
  }

  void _updateStatus(JobStatus status) {
    setState(() {
      _job = _job.copyWith(status: status);
      final idx = DemoData.jobs.indexWhere((j) => j.id == _job.id);
      if (idx != -1) DemoData.jobs[idx] = _job;
    });
  }

  void _capture(bool before) {
    setState(() {
      if (before) {
        _beforePhoto = true;
      } else {
        _afterPhoto = true;
      }
      _gpsVerified = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          before
              ? 'Before photo captured · GPS + timestamp attached'
              : 'After photo captured · service proof ready',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_job.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: StatusChip(status: _job.status)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _infoCard(),
          const SizedBox(height: 16),
          _actions(),
          const SizedBox(height: 20),
          const Text(
            'Site details & entry notes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _notesCard(),
          const SizedBox(height: 20),
          const Text(
            'Work plan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ..._job.workPlan.asMap().entries.map(
                (e) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.teal.withValues(alpha: 0.2),
                    child: Text(
                      '${e.key + 1}',
                      style: const TextStyle(
                        color: AppColors.teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  title: Text(e.value, style: const TextStyle(fontSize: 14)),
                ),
              ),
          const SizedBox(height: 12),
          const Text(
            'Service verification',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _photoTile(
                  label: 'Before',
                  done: _beforePhoto,
                  onTap: () => _capture(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _photoTile(
                  label: 'After',
                  done: _afterPhoto,
                  onTap: () => _capture(false),
                ),
              ),
            ],
          ),
          if (_gpsVerified) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.35),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: AppColors.success, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'GPS verified inside property geofence',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigation opened to site coordinates'),
                ),
              );
            },
            icon: const Icon(Icons.navigation),
            label: const Text('Navigate to Site'),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _job.customer,
            style: const TextStyle(
              color: AppColors.teal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place_outlined,
                  size: 18, color: AppColors.charcoal),
              const SizedBox(width: 6),
              Expanded(child: Text(_job.address)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(Icons.ac_unit, _job.serviceType),
              _pill(Icons.square_foot, '${_job.sqFt.toStringAsFixed(0)} sqft'),
              _pill(Icons.scale, 'Est ${_job.estimatedSaltLbs} lbs salt'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.teal),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _notesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        _job.entryNotes,
        style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
      ),
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _updateStatus(JobStatus.inProgress),
            child: const Text('Start Service'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              if (!_beforePhoto || !_afterPhoto) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Capture before & after photos first'),
                  ),
                );
                return;
              }
              _updateStatus(JobStatus.completed);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service completed & synced')),
              );
            },
            child: const Text('Complete'),
          ),
        ),
      ],
    );
  }

  Widget _photoTile({
    required String label,
    required bool done,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        height: 120,
        decoration: BoxDecoration(
          color: done
              ? AppColors.teal.withValues(alpha: 0.12)
              : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: done ? AppColors.teal : AppColors.cardBorder,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              done ? Icons.check_circle : Icons.camera_alt_outlined,
              color: done ? AppColors.teal : AppColors.charcoal,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              done ? '$label captured' : 'Add $label photo',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: done ? AppColors.teal : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
