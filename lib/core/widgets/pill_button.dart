import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

enum PillVariant { primary, secondary, quiet, destructive }

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PillVariant.primary,
    this.icon,
    this.expand = false,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final PillVariant variant;
  final IconData? icon;
  final bool expand;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null && !busy;

    // White on Amber fails contrast, so the primary CTA keeps Ink text.
    final (background, foreground, border) = switch (variant) {
      PillVariant.primary => (colors.amber, colors.ink, null),
      PillVariant.secondary => (colors.pine, Colors.white, null),
      PillVariant.quiet => (Colors.transparent, colors.pine, colors.border),
      PillVariant.destructive => (colors.dangerPale, colors.danger, null),
    };

    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (busy)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        else if (icon != null)
          Icon(icon, size: 18, color: foreground),
        if (busy || icon != null) const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: context.text.button.copyWith(color: foreground),
          ),
        ),
      ],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: background,
        shape: StadiumBorder(
          side: border == null
              ? BorderSide.none
              : BorderSide(color: border, width: 1.2),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTapTarget,
              minWidth: AppSpacing.minTapTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.sm,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
