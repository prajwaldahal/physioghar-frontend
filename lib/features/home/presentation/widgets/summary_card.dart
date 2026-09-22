import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.onTap,
    this.highlight = false,
  });

  final String label;
  final int count;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      onTap: onTap,
      color: highlight ? colors.amberPale : null,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: highlight ? colors.amber : colors.pine),
          const SizedBox(height: AppSpacing.sm),
          Text('$count', style: context.text.statNumber),
          const SizedBox(height: 2),
          Text(label, style: context.text.meta),
        ],
      ),
    );
  }
}
