import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/patient.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../providers/patients_provider.dart';

class PatientTile extends ConsumerWidget {
  const PatientTile({super.key, required this.patient, required this.onTap});

  final Patient patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastSession = ref.watch(lastSessionDateProvider(patient.id));

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(name: patient.name, size: 44),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: context.text.bodyStrong,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Age ${patient.age} · ${patient.condition}',
                  style: context.text.meta,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  lastSession == null
                      ? 'No sessions yet'
                      : 'Last session: ${formatFullDate(lastSession)}',
                  style: context.text.label,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20, color: context.colors.inkMute),
        ],
      ),
    );
  }
}
