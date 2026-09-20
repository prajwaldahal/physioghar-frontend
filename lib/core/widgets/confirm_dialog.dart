import 'package:flutter/material.dart';

import '../theme/theme_context.dart';

Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  bool destructive = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(
            cancelLabel,
            style: context.text.button.copyWith(color: context.colors.inkMid),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            confirmLabel,
            style: context.text.button.copyWith(
              color: destructive ? context.colors.danger : context.colors.pine,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
