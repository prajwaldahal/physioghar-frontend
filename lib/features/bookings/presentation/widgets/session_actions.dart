import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/booking_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../providers/bookings_provider.dart';
import 'complete_session_sheet.dart';
import 'reschedule_sheet.dart';

class SessionActions extends ConsumerWidget {
  const SessionActions({super.key, required this.session});

  final BookingSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = switch (session.status) {
      SessionStatus.pending => [
        PillButton(
          label: 'Decline',
          variant: PillVariant.destructive,
          onPressed: () => _decline(context, ref),
        ),
        PillButton(label: 'Accept', onPressed: () => _accept(context, ref)),
      ],
      SessionStatus.upcoming => [
        PillButton(
          label: 'Reschedule',
          variant: PillVariant.quiet,
          onPressed: () => _openSheet(
            context,
            (_) => RescheduleSheet(session: session),
          ),
        ),
        PillButton(
          label: 'Mark completed',
          onPressed: () => _openSheet(
            context,
            (_) => CompleteSessionSheet(session: session),
          ),
        ),
      ],
      _ => const <Widget>[],
    };

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      alignment: WrapAlignment.end,
      children: buttons,
    );
  }

  void _openSheet(BuildContext context, WidgetBuilder builder) {
    showAppSheet<void>(context: context, builder: builder);
  }

  Future<void> _accept(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(bookingsProvider.notifier).accept(session.id);
      if (!context.mounted) return;
      showSuccessSnackBar(
        context,
        '${session.patientName} is now in your upcoming sessions.',
      );
    } on BookingException catch (e) {
      if (!context.mounted) return;
      showErrorSnackBar(context, e.message);
    }
  }

  Future<void> _decline(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmAction(
      context,
      title: 'Decline this request?',
      message:
          '${session.patientName} will be told the booking was not accepted.',
      confirmLabel: 'Decline',
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(bookingsProvider.notifier).decline(session.id);
      if (!context.mounted) return;
      showSuccessSnackBar(context, 'Request declined.');
    } on BookingException catch (e) {
      if (!context.mounted) return;
      showErrorSnackBar(context, e.message);
    }
  }
}
