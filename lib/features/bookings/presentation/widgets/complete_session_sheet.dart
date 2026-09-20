import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/booking_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../providers/bookings_provider.dart';

class CompleteSessionSheet extends ConsumerStatefulWidget {
  const CompleteSessionSheet({super.key, required this.session});

  final BookingSession session;

  @override
  ConsumerState<CompleteSessionSheet> createState() =>
      _CompleteSessionSheetState();
}

class _CompleteSessionSheetState extends ConsumerState<CompleteSessionSheet> {
  final _remarks = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _remarks.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(bookingsProvider.notifier)
          .complete(widget.session.id, remarks: _remarks.text);
      if (!mounted) return;
      Navigator.of(context).pop();
      showSuccessSnackBar(context, 'Session marked as completed.');
    } on BookingException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showErrorSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    return SheetScaffold(
      title: 'Mark as completed',
      subtitle:
          '${session.patientName} · ${formatTime(session.startsAt)}, '
          '${relativeDayLabel(session.startsAt)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Therapist remarks (optional)',
            controller: _remarks,
            hint: 'How did the session go?',
            maxLines: 4,
            minLines: 3,
            maxLength: 300,
            textInputAction: TextInputAction.newline,
          ),
          const SizedBox(height: AppSpacing.lg),
          PillButton(
            label: 'Mark completed',
            icon: Icons.check_rounded,
            expand: true,
            busy: _busy,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
