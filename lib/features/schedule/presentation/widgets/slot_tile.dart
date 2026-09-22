import 'package:flutter/material.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/availability_slot.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../providers/schedule_provider.dart';

// Each state differs by colour, icon and label so it never relies on colour alone.
({Color background, Color foreground, IconData icon}) slotStyle(
  BuildContext context,
  SlotState state,
) {
  final colors = context.colors;
  return switch (state) {
    SlotState.open => (
      background: colors.pinePale,
      foreground: colors.pine,
      icon: Icons.check_circle_outline,
    ),
    SlotState.booked => (
      background: colors.pine,
      foreground: Colors.white,
      icon: Icons.person_rounded,
    ),
    SlotState.blocked => (
      background: colors.mist,
      foreground: colors.inkMute,
      icon: Icons.block,
    ),
  };
}

class SlotTile extends StatelessWidget {
  const SlotTile({super.key, required this.resolved, required this.onTap});

  final ResolvedSlot resolved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = slotStyle(context, resolved.state);
    final session = resolved.session;

    return Material(
      color: style.background,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTapTarget + 12,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(style.icon, size: 20, color: style.foreground),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${formatTime(resolved.startsAt)} – '
                        '${formatTime(resolved.slot.endsAt)}',
                        style: context.text.bodyStrong.copyWith(
                          color: style.foreground,
                        ),
                      ),
                      if (session != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${session.patientName} · ${session.treatment}',
                          overflow: TextOverflow.ellipsis,
                          style: context.text.meta.copyWith(
                            color: style.foreground.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  resolved.state.label.toUpperCase(),
                  style: context.text.eyebrow.copyWith(
                    color: style.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
