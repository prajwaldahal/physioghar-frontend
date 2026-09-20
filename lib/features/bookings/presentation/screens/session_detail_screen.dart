import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/booking_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/eyebrow_label.dart';
import '../../../../core/widgets/page_scaffold.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../providers/bookings_provider.dart';
import '../widgets/session_actions.dart';
import '../widgets/session_status_chip.dart';

class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionByIdProvider(sessionId));

    if (session == null) {
      return const PageScaffold(
        title: 'Session',
        showBack: true,
        child: EmptyState(
          icon: Icons.search_off,
          title: 'Session not found',
          message: 'This booking is no longer available.',
        ),
      );
    }

    return PageScaffold(
      title: 'Session details',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageGutter,
          AppSpacing.lg,
          AppSpacing.pageGutter,
          AppSpacing.xxl,
        ),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UserAvatar(name: session.patientName, size: 52),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.patientName,
                            style: context.text.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(session.treatment, style: context.text.bodyMuted),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SessionStatusChip(session.status),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EyebrowLabel('Appointment'),
                const SizedBox(height: AppSpacing.md),
                _Row(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: formatLongDate(session.startsAt),
                ),
                _Row(
                  icon: Icons.schedule,
                  label: 'Time',
                  value:
                      '${formatTime(session.startsAt)} – '
                      '${formatTime(session.endsAt)}',
                ),
                _Row(
                  icon: session.location == SessionLocation.homeVisit
                      ? Icons.home_outlined
                      : Icons.local_hospital_outlined,
                  label: 'Location',
                  value: session.location.label,
                ),
              ],
            ),
          ),
          if (session.status == SessionStatus.completed) ...[
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const EyebrowLabel('Therapist remarks'),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    session.remarks ?? 'No remarks added',
                    style: session.remarks == null
                        ? context.text.bodyMuted
                        : context.text.body,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          SessionActions(session: session),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: context.colors.inkMute),
          const SizedBox(width: AppSpacing.md),
          Text(label, style: context.text.label),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: context.text.bodyStrong,
            ),
          ),
        ],
      ),
    );
  }
}
