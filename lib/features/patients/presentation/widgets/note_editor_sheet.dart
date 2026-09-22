import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/field_rules.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../model/session_note.dart';
import '../../providers/notes_provider.dart';

class NoteEditorSheet extends ConsumerStatefulWidget {
  const NoteEditorSheet({super.key, required this.patientId, this.existing});

  final String patientId;
  final SessionNote? existing;

  @override
  ConsumerState<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends ConsumerState<NoteEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _note = TextEditingController(text: widget.existing?.note ?? '');
  late final _exercises = TextEditingController(
    text: widget.existing?.exercises.join('\n') ?? '',
  );
  late final _plan = TextEditingController(
    text: widget.existing?.nextSessionPlan ?? '',
  );
  bool _busy = false;
  bool _showAllErrors = false;

  @override
  void dispose() {
    _note.dispose();
    _exercises.dispose();
    _plan.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // onUserInteraction never reveals errors on fields the user skipped.
    setState(() => _showAllErrors = true);
    if (!(_formKey.currentState?.validate() ?? false)) {
      showErrorSnackBar(context, 'A session note is required.');
      return;
    }
    setState(() => _busy = true);
    final exercises = _exercises.text.split('\n');
    final existing = widget.existing;
    try {
      if (existing == null) {
        await ref
            .read(notesProvider.notifier)
            .add(
              patientId: widget.patientId,
              note: _note.text,
              exercises: exercises,
              nextSessionPlan: _plan.text,
            );
      } else {
        await ref
            .read(notesProvider.notifier)
            .edit(
              id: existing.id,
              note: _note.text,
              exercises: exercises,
              nextSessionPlan: _plan.text,
            );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      showSuccessSnackBar(
        context,
        existing == null ? 'Note saved.' : 'Note updated.',
      );
    } on NoteException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showErrorSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return SheetScaffold(
      title: editing ? 'Edit note' : 'Add a session note',
      subtitle: 'Exercises go one per line.',
      child: Form(
        key: _formKey,
        autovalidateMode: _showAllErrors
            ? AutovalidateMode.always
            : AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Session note',
              controller: _note,
              hint: 'What happened in this session?',
              maxLines: 4,
              minLines: 3,
              maxLength: 400,
              validator: (v) => FieldRules.required(v, 'Session note'),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Exercises (optional)',
              controller: _exercises,
              hint: 'Knee flexion\nStretching',
              maxLines: 4,
              minLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Next session plan (optional)',
              controller: _plan,
              hint: 'What to focus on next time',
              maxLines: 3,
              minLines: 2,
              maxLength: 200,
            ),
            const SizedBox(height: AppSpacing.xl),
            PillButton(
              label: editing ? 'Update note' : 'Save note',
              icon: Icons.check_rounded,
              expand: true,
              busy: _busy,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
