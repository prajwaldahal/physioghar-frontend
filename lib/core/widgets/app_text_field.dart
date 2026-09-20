import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.initialValue,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.label),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          enabled: enabled,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          style: context.text.body,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
