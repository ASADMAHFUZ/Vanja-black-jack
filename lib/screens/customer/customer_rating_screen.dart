import 'package:material_ui/material_ui.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class CustomerRatingScreen extends StatefulWidget {
  final CustomerTrackingSession session;

  const CustomerRatingScreen({super.key, required this.session});

  @override
  State<CustomerRatingScreen> createState() => _CustomerRatingScreenState();
}

class _CustomerRatingScreenState extends State<CustomerRatingScreen> {
  int _stars = 0;
  final _feedbackController = TextEditingController();
  bool _submitted = false;
  bool _busy = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_stars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating')),
      );
      return;
    }
    setState(() => _busy = true);
    final controller = TrackingScope.of(context);
    await controller.submitRating(_stars, _feedbackController.text);
    if (!mounted) return;
    setState(() {
      _submitted = true;
      _busy = false;
    });
    if (_stars < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback sent to admin quality dashboard'),
        ),
      );
    }
  }

  Future<void> _openGoogle() async {
    final controller = TrackingScope.of(context);
    final ok = await controller.openGoogleReviews();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Reviews')),
      );
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isFiveStar = _stars == 5;

    return Scaffold(
      appBar: AppBar(title: const Text('Rate your service')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'How was snow clearing at your property?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            widget.session.propertyAddress,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final value = i + 1;
              final selected = value <= _stars;
              return IconButton(
                onPressed:
                    _submitted ? null : () => setState(() => _stars = value),
                iconSize: 38,
                icon: Icon(
                  selected ? Icons.star_rounded : Icons.star_border_rounded,
                  color: selected ? AppColors.warning : AppColors.charcoal,
                ),
              );
            }),
          ),
          Text(
            _stars == 0
                ? 'Tap a star'
                : isFiveStar
                    ? 'Excellent — thank you!'
                    : 'We will review this internally',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          if (_stars > 0 && _stars < 5 && !_submitted) ...[
            const SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'What could we improve? (internal only)',
                alignLabelWithHint: true,
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (!_submitted)
            ElevatedButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Submit rating'),
            ),
          if (_submitted && isFiveStar) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.teal.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Share on Google Reviews?',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '5-star feedback helps neighbours find Black Jack Tracking.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: _openGoogle,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open Google Reviews'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Not now'),
                  ),
                ],
              ),
            ),
          ],
          if (_submitted && !isFiveStar) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.35),
                ),
              ),
              child: const Text(
                'Your rating stays internal and was saved for the admin feedback dashboard. It will not appear on Google.',
                style: TextStyle(height: 1.4, fontSize: 13),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ],
      ),
    );
  }
}
