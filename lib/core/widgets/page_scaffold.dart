import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showBack = false,
    this.floatingActionButton,
    this.backgroundColor,
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              automaticallyImplyLeading: showBack,
              actions: actions,
            ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        top: title == null,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.contentMaxWidth,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
