import 'package:flutter/material.dart';

import '../theme/theme_context.dart';

class EyebrowLabel extends StatelessWidget {
  const EyebrowLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: color == null
          ? context.text.eyebrow
          : context.text.eyebrow.copyWith(color: color),
    );
  }
}
