import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';
import 'pill_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.dangerPale,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 30,
                color: colors.danger,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: context.text.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message ?? 'We could not load this just now.',
              textAlign: TextAlign.center,
              style: context.text.bodyMuted,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PillButton(
                label: 'Try again',
                icon: Icons.refresh,
                onPressed: onRetry,
                variant: PillVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
