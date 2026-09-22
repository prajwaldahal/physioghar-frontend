import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../providers/schedule_provider.dart';

class AvailabilityToggle extends ConsumerWidget {
  const AvailabilityToggle({super.key, this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final available = ref.watch(availabilityStatusProvider);
    final colors = context.colors;
    final labelColor = onDark ? Colors.white : colors.ink;

    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: available ? colors.amber : colors.inkMute,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            available ? l10n.available : l10n.unavailable,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodyStrong.copyWith(color: labelColor),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Switch(
          value: available,
          onChanged: (value) {
            ref.read(availabilityStatusProvider.notifier).setAvailable(value);
            showInfoSnackBar(
              context,
              value
                  ? 'You are marked available for new bookings.'
                  : 'You are marked unavailable for new bookings.',
            );
          },
          activeThumbColor: Colors.white,
          activeTrackColor: colors.amber,
        ),
      ],
    );
  }
}
