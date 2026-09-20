import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  _show(
    context,
    message: message,
    icon: Icons.check_circle_outline,
    background: context.colors.pine,
    foreground: Colors.white,
    duration: const Duration(seconds: 2),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  _show(
    context,
    message: message,
    icon: Icons.error_outline,
    background: context.colors.danger,
    foreground: Colors.white,
    duration: const Duration(seconds: 4),
  );
}

void showInfoSnackBar(BuildContext context, String message) {
  _show(
    context,
    message: message,
    icon: Icons.info_outline,
    background: context.colors.ink,
    foreground: Colors.white,
    duration: const Duration(seconds: 3),
  );
}

void _show(
  BuildContext context, {
  required String message,
  required IconData icon,
  required Color background,
  required Color foreground,
  required Duration duration,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: background,
        duration: duration,
        content: Row(
          children: [
            Icon(icon, color: foreground, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: context.text.body.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
}
