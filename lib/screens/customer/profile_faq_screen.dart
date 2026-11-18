import 'package:material_ui/material_ui.dart';
import '../../theme/app_theme.dart';

class ProfileFaqScreen extends StatelessWidget {
  const ProfileFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const faqs = [
      (
        'How do I track my plow?',
        'Open the SMS or email tracking link. Home shows live status; Mapping shows the Google Map route.'
      ),
      (
        'What does “stops away” mean?',
        'It is how many properties remain before your assigned operator reaches your driveway.'
      ),
      (
        'When do I get a proximity alert?',
        'When the plow is about 5 stops away, if proximity alerts are enabled in Settings.'
      ),
      (
        'Why can’t I pay in this app?',
        'Billing and invoicing are handled outside this platform. This app is for service tracking only.'
      ),
      (
        'Where do my ratings go?',
        '5★ may open Google Reviews. Ratings under 5★ stay internal for quality control.'
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = faqs[index];
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
                  item.$1,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  item.$2,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
