import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_header.dart';
import '../../widgets/daily_temperature_card.dart';
import 'customer_rating_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TrackingScope.of(context);
    final session = controller.session;
    final tracking = session.phase == ServicePhase.tracking;
    final completed = session.phase == ServicePhase.completed;
    final rated = session.phase == ServicePhase.rated;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const BrandHeader(compact: true),
            const SizedBox(height: 16),
            Text(
              tracking
                  ? 'Your plow is on the way'
                  : completed
                      ? 'Service complete'
                      : 'Thanks for your feedback',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Hi ${session.customerName.split(' ').first} · ${session.trackingCode}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            const DailyTemperatureCard(),
            const SizedBox(height: 12),
            if (tracking &&
                session.proximityAlertSent &&
                controller.prefs.proximityAlerts) ...[
              _alertCard(session.stopsAway),
              const SizedBox(height: 12),
            ],
            _statusCard(session, tracking, completed),
            const SizedBox(height: 12),
            _addressCard(session),
            const SizedBox(height: 12),
            _operatorCard(session),
            const SizedBox(height: 12),
            _activityCard(session),
            const SizedBox(height: 16),
            if (tracking) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.advanceOperator,
                      icon: const Icon(Icons.near_me),
                      label: Text(
                        session.stopsAway > 1
                            ? 'Update location'
                            : 'Complete service',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: session.liveUpdatesEnabled
                        ? controller.pauseLiveTracking
                        : controller.startLiveTracking,
                    child: Icon(
                      session.liveUpdatesEnabled
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                session.liveUpdatesEnabled
                    ? 'Live updates on · auto-refresh every 4s'
                    : 'Live updates paused',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 12,
                ),
              ),
            ],
            if (completed)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CustomerRatingScreen(session: session),
                    ),
                  );
                },
                icon: const Icon(Icons.star_rate_rounded),
                label: const Text('Leave a star rating'),
              ),
            if (rated)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.softTeal,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.teal.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  session.rating == 5
                      ? 'You rated 5★ — Google Reviews was offered.'
                      : 'You rated ${session.rating}★ — feedback sent to admin quality dashboard.',
                  style: const TextStyle(height: 1.4),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _alertCard(int stopsAway) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softTeal,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: AppColors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Proximity alert: plow is $stopsAway stop${stopsAway == 1 ? '' : 's'} away.',
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(
    CustomerTrackingSession session,
    bool tracking,
    bool completed,
  ) {
    final color = tracking
        ? AppColors.teal
        : completed
            ? AppColors.success
            : AppColors.warning;
    final title = tracking
        ? 'Live tracking'
        : completed
            ? 'Property cleared'
            : 'Rating submitted';
    final body = tracking
        ? 'Operator ${session.operatorName} is ${session.stopsAway} stops away.'
        : completed
            ? 'Operator finished your property at ${DateFormat.jm().format(session.finishedAt!)}'
            : 'Thank you for helping improve service quality.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            tracking
                ? Icons.gps_fixed
                : completed
                    ? Icons.check_circle
                    : Icons.star_rounded,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressCard(CustomerTrackingSession session) {
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
          const Text(
            'Service address',
            style: TextStyle(color: AppColors.teal, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            session.propertyAddress,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _operatorCard(CustomerTrackingSession session) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.teal.withValues(alpha: 0.15),
            child: const Icon(Icons.local_shipping, color: AppColors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.operatorName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  session.vehicle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (session.phase == ServicePhase.tracking)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.softTeal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                session.liveUpdatesEnabled ? 'Live' : 'Paused',
                style: const TextStyle(
                  color: AppColors.tealDim,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _activityCard(CustomerTrackingSession session) {
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
          const Text(
            'Activity',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...session.activityLog.take(5).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Icon(Icons.circle, size: 6, color: AppColors.teal),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
