import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/booking_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../providers/bookings_provider.dart';

class RescheduleSheet extends ConsumerStatefulWidget {
  const RescheduleSheet({super.key, required this.session});

  final BookingSession session;

  @override
  ConsumerState<RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends ConsumerState<RescheduleSheet> {
  late DateTime _date = dateOnly(widget.session.startsAt);
  DateTime? _selected;
  bool _busy = false;

  static const _horizonDays = 14;

  List<DateTime> get _dates {
    final start = startOfWeek(DateTime.now());
    return [
      for (var i = 0; i < _horizonDays; i++) start.add(Duration(days: i)),
    ].where((d) => !d.isBefore(dateOnly(DateTime.now()))).toList();
  }

  Future<void> _submit() async {
    final target = _selected;
    if (target == null) {
      showErrorSnackBar(context, 'Pick a new time first.');
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(bookingsProvider.notifier)
          .reschedule(widget.session.id, target);
      if (!mounted) return;
      Navigator.of(context).pop();
      showSuccessSnackBar(
        context,
        'Moved to ${formatTime(target)}, ${relativeDayLabel(target)}.',
      );
    } on BookingException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showErrorSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(rescheduleOptionsProvider(_date));

    return SheetScaffold(
      title: 'Reschedule session',
      subtitle:
          'Currently ${formatTime(widget.session.startsAt)}, '
          '${relativeDayLabel(widget.session.startsAt)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Choose a date', style: context.text.label),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final date = _dates[index];
                return _DateChip(
                  date: date,
                  selected: isSameDay(date, _date),
                  onTap: () => setState(() {
                    _date = date;
                    _selected = null;
                  }),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Available times', style: context.text.label),
          const SizedBox(height: AppSpacing.sm),
          if (options.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                'No free times on this day. Try another date.',
                style: context.text.bodyMuted,
              ),
            )
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final option in options)
                  _TimeChip(
                    time: option,
                    selected: _selected == option,
                    onTap: () => setState(() => _selected = option),
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
          PillButton(
            label: 'Confirm new time',
            expand: true,
            busy: _busy,
            onPressed: options.isEmpty ? null : _submit,
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.pine : colors.mist,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: 56,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatWeekdayShort(date),
                style: context.text.meta.copyWith(
                  color: selected ? Colors.white70 : colors.inkMute,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${date.day}',
                style: context.text.bodyStrong.copyWith(
                  color: selected ? Colors.white : colors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.time,
    required this.selected,
    required this.onTap,
  });

  final DateTime time;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.pine : colors.pinePale,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTapTarget,
            minWidth: 84,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            formatTime(time),
            style: context.text.chip.copyWith(
              color: selected ? Colors.white : colors.pine,
            ),
          ),
        ),
      ),
    );
  }
}
