import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/availability_slot.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../providers/slots_provider.dart';

class AddSlotSheet extends ConsumerStatefulWidget {
  const AddSlotSheet({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<AddSlotSheet> createState() => _AddSlotSheetState();
}

class _AddSlotSheetState extends ConsumerState<AddSlotSheet> {
  TimeOfDay? _time;
  bool _busy = false;

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Start time',
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    final time = _time;
    if (time == null) {
      showErrorSnackBar(context, 'Choose a start time first.');
      return;
    }
    setState(() => _busy = true);
    final startsAt = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      time.hour,
      time.minute,
    );
    try {
      await ref.read(slotsProvider.notifier).addSlot(startsAt);
      if (!mounted) return;
      Navigator.of(context).pop();
      showSuccessSnackBar(context, 'Added a slot at ${formatTime(startsAt)}.');
    } on ScheduleException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showErrorSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = _time;
    return SheetScaffold(
      title: 'Add an available slot',
      subtitle: formatLongDate(widget.date),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Start time', style: context.text.label),
          const SizedBox(height: AppSpacing.sm),
          Material(
            color: context.colors.mist,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: InkWell(
              onTap: _pickTime,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: AppSpacing.minTapTarget + 8,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: context.colors.inkMute,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        time == null
                            ? 'Choose a time'
                            : time.format(context),
                        style: time == null
                            ? context.text.bodyMuted
                            : context.text.bodyStrong,
                      ),
                    ),
                    Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: context.colors.inkMute,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Slots are ${AvailabilitySlot.duration.inMinutes} minutes long.',
            style: context.text.meta,
          ),
          const SizedBox(height: AppSpacing.xl),
          PillButton(
            label: 'Add slot',
            icon: Icons.add,
            expand: true,
            busy: _busy,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
