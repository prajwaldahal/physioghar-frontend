import 'package:flutter/material.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/state_chip.dart';
import '../../model/complaint.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({super.key, required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  complaint.subject,
                  style: context.text.bodyStrong,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StateChip(
                complaint.status.label,
                tone: complaint.status == ComplaintStatus.open
                    ? ChipTone.pending
                    : ChipTone.done,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(complaint.description, style: context.text.bodyMuted),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: [
              Text(complaint.reference, style: context.text.eyebrow),
              Text(complaint.category.label, style: context.text.meta),
              Text(formatFullDate(complaint.createdAt), style: context.text.meta),
            ],
          ),
        ],
      ),
    );
  }
}
