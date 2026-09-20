import 'package:flutter/material.dart';

import '../theme/theme_context.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.background,
    this.foreground,
  });

  final String name;
  final double size;
  final Color? background;
  final Color? foreground;

  static String initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? colors.pinePale,
        shape: BoxShape.circle,
      ),
      child: Text(
        initialsOf(name),
        style: context.text.bodyStrong.copyWith(
          color: foreground ?? colors.pine,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
