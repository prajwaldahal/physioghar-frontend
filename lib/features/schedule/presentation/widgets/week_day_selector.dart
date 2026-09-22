import 'package:flutter/material.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

class WeekDaySelector extends StatelessWidget {
  const WeekDaySelector({
    super.key,
    required this.days,
    required this.selected,
    required this.onSelect,
  });

  final List<DateTime> days;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      child: Row(
        children: [
          for (final day in days)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _DayCell(
                day: day,
                selected: isSameDay(day, selected),
                today: isToday(day),
                onTap: () => onSelect(day),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.today,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = selected ? colors.pine : colors.surface;
    final foreground = selected ? Colors.white : colors.ink;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: 52,
          constraints: const BoxConstraints(minHeight: 66),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: selected ? colors.pine : colors.border,
              width: today && !selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatWeekdayShort(day),
                style: context.text.meta.copyWith(
                  color: selected ? Colors.white70 : colors.inkMute,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${day.day}',
                style: context.text.bodyStrong.copyWith(color: foreground),
              ),
              const SizedBox(height: 4),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: today
                      ? (selected ? Colors.white : colors.amber)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
