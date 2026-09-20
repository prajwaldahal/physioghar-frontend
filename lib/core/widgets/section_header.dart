import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.count,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final int? count;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              style: context.text.title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text('$count', style: context.text.label),
          ],
          const Spacer(),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                minimumSize: const Size(
                  AppSpacing.minTapTarget,
                  AppSpacing.minTapTarget,
                ),
                foregroundColor: context.colors.pine,
              ),
              child: Text(
                actionLabel!,
                style: context.text.label.copyWith(
                  color: context.colors.pine,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
