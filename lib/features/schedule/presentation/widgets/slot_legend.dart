import 'package:flutter/material.dart';

import '../../../../core/models/availability_slot.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import 'slot_tile.dart';

class SlotLegend extends StatelessWidget {
  const SlotLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        for (final state in SlotState.values) _LegendItem(state: state),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.state});

  final SlotState state;

  @override
  Widget build(BuildContext context) {
    final style = slotStyle(context, state);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm / 2),
          ),
          child: Icon(style.icon, size: 11, color: style.foreground),
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        Text(state.label, style: context.text.meta),
      ],
    );
  }
}
