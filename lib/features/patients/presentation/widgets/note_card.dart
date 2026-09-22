import 'package:flutter/material.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/eyebrow_label.dart';
import '../../model/session_note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note, required this.onEdit});

  final SessionNote note;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final stamp = note.isEdited
        ? 'Edited ${formatDateTime(note.updatedAt!)}'
        : 'Added ${formatDateTime(note.createdAt)}';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(stamp, style: context.text.meta)),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: context.colors.pine,
                tooltip: 'Edit note',
                constraints: const BoxConstraints(
                  minWidth: AppSpacing.minTapTarget,
                  minHeight: AppSpacing.minTapTarget,
                ),
              ),
            ],
          ),
          Text(note.note, style: context.text.body),
          if (note.exercises.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const EyebrowLabel('Exercises'),
            const SizedBox(height: AppSpacing.xs),
            for (final exercise in note.exercises)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text('• $exercise', style: context.text.bodyMuted),
              ),
          ],
          if (note.nextSessionPlan != null) ...[
            const SizedBox(height: AppSpacing.md),
            const EyebrowLabel('Next session'),
            const SizedBox(height: AppSpacing.xs),
            Text(note.nextSessionPlan!, style: context.text.bodyMuted),
          ],
        ],
      ),
    );
  }
}
