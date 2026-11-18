import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import '../data/demo_data.dart';
import '../models/job.dart';
import '../theme/app_theme.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final _amountController = TextEditingController();
  String _material = 'Rock Salt';
  String _jobId = DemoData.jobs.first.id;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _logMaterial() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }
    setState(() {
      DemoData.materialLogs.insert(
        0,
        MaterialLog(
          jobId: _jobId,
          material: _material,
          amount: amount,
          unit: 'lbs',
          loggedAt: DateTime.now(),
        ),
      );
      _amountController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged $amount lbs of $_material')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSalt = DemoData.materialLogs
        .where((m) => m.material.contains('Salt'))
        .fold<double>(0, (sum, m) => sum + m.amount);

    return Scaffold(
      appBar: AppBar(title: const Text('Material Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _statCard('Salt today', '${totalSalt.toStringAsFixed(0)} lbs'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  'Rate target',
                  '20 lbs / 1k sqft',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Log consumables',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _jobId,
                  decoration: const InputDecoration(labelText: 'Property'),
                  items: DemoData.jobs
                      .map(
                        (j) => DropdownMenuItem(
                          value: j.id,
                          child: Text(j.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _jobId = v ?? _jobId),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _material,
                  decoration: const InputDecoration(labelText: 'Material'),
                  items: const [
                    DropdownMenuItem(value: 'Rock Salt', child: Text('Rock Salt')),
                    DropdownMenuItem(value: 'Sand', child: Text('Sand')),
                    DropdownMenuItem(
                      value: 'Liquid De-icer',
                      child: Text('Liquid De-icer'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _material = v ?? _material),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (lbs)',
                    prefixIcon: Icon(Icons.scale_outlined, color: AppColors.teal),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logMaterial,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Log Entry'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Estimated vs Actual',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...DemoData.jobs.take(3).map(_compareRow),
          const SizedBox(height: 24),
          const Text(
            'Recent logs',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...DemoData.materialLogs.map(_logTile),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _compareRow(JobSite job) {
    final actual = DemoData.materialLogs
        .where((m) => m.jobId == job.id)
        .fold<double>(0, (s, m) => s + m.amount);
    final estimated = double.tryParse(job.estimatedSaltLbs) ?? 0;
    final pct = estimated == 0 ? 0.0 : (actual / estimated).clamp(0.0, 1.5);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Est ${job.estimatedSaltLbs} lbs',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                'Actual ${actual.toStringAsFixed(0)} lbs',
                style: const TextStyle(
                  color: AppColors.teal,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct > 1 ? 1 : pct,
              minHeight: 6,
              backgroundColor: AppColors.cardBorder,
              color: pct > 1 ? AppColors.warning : AppColors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logTile(MaterialLog log) {
    final jobName = DemoData.jobs
        .firstWhere(
          (j) => j.id == log.jobId,
          orElse: () => DemoData.jobs.first,
        )
        .name;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.teal.withValues(alpha: 0.15),
        child: const Icon(Icons.inventory_2_outlined, color: AppColors.teal),
      ),
      title: Text('${log.amount.toStringAsFixed(0)} ${log.unit} · ${log.material}'),
      subtitle: Text(
        '$jobName · ${DateFormat.jm().format(log.loggedAt)}',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    );
  }
}
