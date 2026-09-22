import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/booking_session.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../bookings/presentation/widgets/session_card.dart';
import '../../../bookings/providers/bookings_provider.dart';
import '../../providers/dashboard_providers.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final bookings = ref.watch(bookingsProvider);

    return Scaffold(
      body: switch (bookings) {
        AsyncLoading() => const LoadingView(message: 'Loading your day'),
        AsyncError(:final error) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(bookingsProvider),
        ),
        _ => _DashboardBody(l10n: l10n),
      },
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.l10n});

  final AppL10n l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todaySessionsProvider);
    final upcoming = ref.watch(upcomingAfterTodayProvider);
    final requests = ref.watch(pendingRequestsProvider);
    final completed = ref.watch(completedSessionsProvider);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        const DashboardHeader(),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
          ),
          // IntrinsicHeight gives the three cards a common height; stretch alone
          // would ask for infinite height inside the scrolling list.
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SummaryCard(
                    label: l10n.todaysSessions,
                    count: today.length,
                    icon: Icons.today_outlined,
                    onTap: () => context.go(
                      AppRoutes.bookingsTab('upcoming'),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryCard(
                    label: l10n.upcomingRequests,
                    count: requests.length,
                    icon: Icons.mark_email_unread_outlined,
                    highlight: requests.isNotEmpty,
                    onTap: () => context.go(
                      AppRoutes.bookingsTab('requests'),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryCard(
                    label: l10n.completedSessions,
                    count: completed.length,
                    icon: Icons.task_alt,
                    onTap: () => context.go(
                      AppRoutes.bookingsTab('completed'),
                    ),
                  ),
                ),
              ],
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.sectionGap),
        _Section(
          title: l10n.todaysSchedule,
          sessions: today,
          showDate: false,
          emptyIcon: Icons.free_breakfast_outlined,
          emptyTitle: l10n.noSessionsToday,
          emptyMessage: l10n.noSessionsTodayMessage,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        _Section(
          title: l10n.upcomingSessions,
          sessions: upcoming,
          showDate: true,
          emptyIcon: Icons.event_available_outlined,
          emptyTitle: l10n.noUpcomingSessions,
          emptyMessage: l10n.noUpcomingSessionsMessage,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.sessions,
    required this.showDate,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  final String title;
  final List<BookingSession> sessions;
  final bool showDate;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: title, count: sessions.length),
          if (sessions.isEmpty)
            EmptyState(
              icon: emptyIcon,
              title: emptyTitle,
              message: emptyMessage,
              compact: true,
            )
          else
            for (final session in sessions)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SessionCard(
                  session: session,
                  showDate: showDate,
                  onTap: () =>
                      context.push(AppRoutes.sessionDetail(session.id)),
                ),
              ),
        ],
      ),
    );
  }
}
