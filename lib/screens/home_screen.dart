import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import '../data/demo_data.dart';
import '../models/job.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_header.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _onShift = false;
  DateTime? _shiftStarted;

  void _toggleShift() {
    setState(() {
      _onShift = !_onShift;
      _shiftStarted = _onShift ? DateTime.now() : null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _onShift
              ? 'Shift started — GPS tracking active'
              : 'Shift ended — hours logged',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = DemoData.jobs
        .where((j) => j.status != JobStatus.completed)
        .toList();
    final weather = '22°F · Snow expected 3–5"';

    return Scaffold(
      appBar: AppBar(
        title: const BrandHeader(compact: true),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _weatherBanner(weather),
          const SizedBox(height: 16),
          _shiftCard(),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Today\'s Assignments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '${active.length} active',
                style: const TextStyle(color: AppColors.teal, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...active.map(
            (job) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: JobCard(
                job: job,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _quickActions(),
        ],
      ),
    );
  }

  Widget _weatherBanner(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF163A38), Color(0xFF1C1C1C)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.ac_unit, color: AppColors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weather Intelligence',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(text, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shiftCard() {
    final timeLabel = _shiftStarted == null
        ? 'Not on shift'
        : 'Started ${DateFormat.jm().format(_shiftStarted!)}';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _onShift
              ? AppColors.teal.withValues(alpha: 0.5)
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.teal.withValues(alpha: 0.2),
                child: Text(
                  DemoData.operatorName.split(' ').map((e) => e[0]).join(),
                  style: const TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DemoData.operatorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${DemoData.crewId} · ${DemoData.vehicle}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _onShift ? AppColors.success : AppColors.charcoal,
                  boxShadow: _onShift
                      ? [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            timeLabel,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _toggleShift,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _onShift ? AppColors.danger : AppColors.teal,
                foregroundColor:
                    _onShift ? Colors.white : AppColors.black,
              ),
              icon: Icon(_onShift ? Icons.stop_circle : Icons.play_arrow),
              label: Text(_onShift ? 'Clock Out' : 'One-Tap Clock In'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _actionTile(
            Icons.camera_alt_outlined,
            'Photo Proof',
            () {
              final job = DemoData.jobs.first;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionTile(
            Icons.navigation_outlined,
            'Navigate',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening next site route…')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _actionTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.teal),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
