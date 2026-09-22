import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/slots_provider.dart';
import '../widgets/add_slot_sheet.dart';
import '../widgets/availability_toggle.dart';
import '../widgets/slot_actions_sheet.dart';
import '../widgets/slot_legend.dart';
import '../widgets/slot_tile.dart';
import '../widgets/week_day_selector.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final slots = ref.watch(slotsProvider);
    final selected = ref.watch(selectedScheduleDateProvider);
    final week = ref.watch(scheduleWeekProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSchedule)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAppSheet<void>(
          context: context,
          builder: (_) => AddSlotSheet(date: selected),
        ),
        backgroundColor: context.colors.amber,
        foregroundColor: context.colors.ink,
        icon: const Icon(Icons.add),
        label: const Text('Add slot'),
      ),
      body: SafeArea(
        top: false,
        child: switch (slots) {
          AsyncLoading() => const LoadingView(message: 'Loading your week'),
          AsyncError(:final error) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(slotsProvider),
          ),
          _ => _ScheduleBody(selected: selected, week: week),
        },
      ),
    );
  }
}

class _ScheduleBody extends ConsumerWidget {
  const _ScheduleBody({required this.selected, required this.week});

  final DateTime selected;
  final List<DateTime> week;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daySlots = ref.watch(daySlotsProvider(selected));
    final openCount = ref.watch(dayOpenCountProvider(selected));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        WeekDaySelector(
          days: week,
          selected: selected,
          onSelect: (date) =>
              ref.read(selectedScheduleDateProvider.notifier).select(date),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
          ),
          child: AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: const AvailabilityToggle(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  relativeDayLabel(selected),
                  style: context.text.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('$openCount open', style: context.text.label),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
          ),
          child: const SlotLegend(),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: daySlots.isEmpty
              ? const EmptyState(
                  icon: Icons.event_busy_outlined,
                  title: 'No slots on this day',
                  message: 'Add a slot to open this day for bookings.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageGutter,
                    0,
                    AppSpacing.pageGutter,
                    AppSpacing.xxl + AppSpacing.xl,
                  ),
                  itemCount: daySlots.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final resolved = daySlots[index];
                    return SlotTile(
                      resolved: resolved,
                      onTap: () => showAppSheet<void>(
                        context: context,
                        builder: (_) => SlotActionsSheet(resolved: resolved),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
