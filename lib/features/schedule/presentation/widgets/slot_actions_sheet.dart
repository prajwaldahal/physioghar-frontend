import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/availability_slot.dart';
import '../../../../core/models/booking_session.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/slots_provider.dart';

class SlotActionsSheet extends ConsumerWidget {
  const SlotActionsSheet({super.key, required this.resolved});

  final ResolvedSlot resolved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = resolved.session;
    final range =
        '${formatTime(resolved.startsAt)} – ${formatTime(resolved.slot.endsAt)}';

    return SheetScaffold(
      title: range,
      subtitle: formatLongDate(resolved.startsAt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (resolved.state == SlotState.booked && session != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colors.pinePale,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.patientName, style: context.text.bodyStrong),
                  const SizedBox(height: 2),
                  Text(
                    '${session.treatment} · ${session.location.label}',
                    style: context.text.bodyMuted,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'A booked slot cannot be blocked. Move or complete the session first.',
              style: context.text.meta,
            ),
            const SizedBox(height: AppSpacing.lg),
            PillButton(
              label: 'View session details',
              icon: Icons.open_in_new,
              expand: true,
              variant: PillVariant.secondary,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.sessionDetail(session.id));
              },
            ),
          ] else if (resolved.state == SlotState.blocked)
            PillButton(
              label: 'Unblock this slot',
              icon: Icons.lock_open_rounded,
              expand: true,
              onPressed: () => _unblock(context, ref),
            )
          else
            PillButton(
              label: 'Block this slot',
              icon: Icons.block,
              expand: true,
              variant: PillVariant.destructive,
              onPressed: () => _block(context, ref),
            ),
        ],
      ),
    );
  }

  Future<void> _block(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(slotsProvider.notifier).block(resolved.slot.id);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      showSuccessSnackBar(
        context,
        '${formatTime(resolved.startsAt)} is now blocked.',
      );
    } on ScheduleException catch (e) {
      if (!context.mounted) return;
      showErrorSnackBar(context, e.message);
    }
  }

  Future<void> _unblock(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(slotsProvider.notifier).unblock(resolved.slot.id);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      showSuccessSnackBar(
        context,
        '${formatTime(resolved.startsAt)} is open again.',
      );
    } on ScheduleException catch (e) {
      if (!context.mounted) return;
      showErrorSnackBar(context, e.message);
    }
  }
}
