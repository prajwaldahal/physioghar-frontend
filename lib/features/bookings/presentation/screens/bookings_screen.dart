import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/booking_session.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../providers/bookings_provider.dart';
import '../widgets/session_actions.dart';
import '../widgets/session_card.dart';

enum BookingsTab { requests, upcoming, completed, cancelled }

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key, this.initialTab});

  final String? initialTab;

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(
    length: BookingsTab.values.length,
    vsync: this,
    initialIndex: _indexOf(widget.initialTab),
  );

  static int _indexOf(String? name) {
    final match = BookingsTab.values.where((t) => t.name == name);
    return match.isEmpty ? 0 : match.first.index;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: context.colors.pine,
          unselectedLabelColor: context.colors.inkMute,
          indicatorColor: context.colors.pine,
          labelStyle: context.text.bodyStrong,
          unselectedLabelStyle: context.text.body,
          tabs: [
            _tab('Requests', ref.watch(pendingRequestsProvider).length),
            _tab('Upcoming', ref.watch(upcomingSessionsProvider).length),
            _tab('Completed', ref.watch(completedSessionsProvider).length),
            _tab('Cancelled', ref.watch(cancelledSessionsProvider).length),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: switch (bookings) {
          AsyncLoading() => const LoadingView(message: 'Loading bookings'),
          AsyncError(:final error) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(bookingsProvider),
          ),
          _ => TabBarView(
            controller: _controller,
            children: [
              _SessionList(
                sessions: ref.watch(pendingRequestsProvider),
                emptyIcon: Icons.inbox_outlined,
                emptyTitle: 'No pending requests',
                emptyMessage: 'New booking requests will show up here.',
              ),
              _SessionList(
                sessions: ref.watch(upcomingSessionsProvider),
                emptyIcon: Icons.event_available_outlined,
                emptyTitle: 'No upcoming sessions',
                emptyMessage: 'Accept a request to see it here.',
              ),
              _SessionList(
                sessions: ref.watch(completedSessionsProvider),
                emptyIcon: Icons.task_alt,
                emptyTitle: 'No completed sessions',
                emptyMessage: 'Sessions you finish will be listed here.',
              ),
              _SessionList(
                sessions: ref.watch(cancelledSessionsProvider),
                emptyIcon: Icons.event_busy_outlined,
                emptyTitle: 'Nothing cancelled',
                emptyMessage: 'Declined and cancelled bookings appear here.',
              ),
            ],
          ),
        },
      ),
    );
  }

  Widget _tab(String label, int count) => Tab(text: '$label ($count)');
}

class _SessionList extends StatelessWidget {
  const _SessionList({
    required this.sessions,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  final List<BookingSession> sessions;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return EmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
      );
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.contentMaxWidth),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageGutter,
            AppSpacing.lg,
            AppSpacing.pageGutter,
            AppSpacing.xxl,
          ),
          itemCount: sessions.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final session = sessions[index];
            return SessionCard(
              session: session,
              onTap: () =>
                  context.push(AppRoutes.sessionDetail(session.id)),
              actions: SessionActions(session: session),
            );
          },
        ),
      ),
    );
  }
}
