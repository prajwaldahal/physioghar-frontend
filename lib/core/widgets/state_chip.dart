import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

enum ChipTone { pending, active, done, danger, neutral }

class StateChip extends StatelessWidget {
  const StateChip(this.label, {super.key, this.tone = ChipTone.neutral, this.icon});

  final String label;
  final ChipTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      ChipTone.pending => (colors.amberPale, colors.ink),
      ChipTone.active => (colors.pinePale, colors.pine),
      ChipTone.done => (colors.pine, Colors.white),
      ChipTone.danger => (colors.dangerPale, colors.danger),
      ChipTone.neutral => (colors.mist, colors.inkMute),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: AppSpacing.xs + 2),
          ],
          Text(label, style: context.text.chip.copyWith(color: foreground)),
        ],
      ),
    );
  }
}
