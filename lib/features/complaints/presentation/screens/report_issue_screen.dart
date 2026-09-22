import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/field_rules.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/page_scaffold.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../model/complaint.dart';
import '../../providers/complaints_provider.dart';

class ReportIssueScreen extends ConsumerStatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  ConsumerState<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends ConsumerState<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _description = TextEditingController();
  ComplaintCategory? _category;
  bool _categoryTouched = false;
  bool _showAllErrors = false;
  bool _busy = false;
  Complaint? _submitted;

  @override
  void dispose() {
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _categoryTouched = true;
      // onUserInteraction never reveals errors on fields the user skipped.
      _showAllErrors = true;
    });
    final validForm = _formKey.currentState?.validate() ?? false;
    if (_category == null || !validForm) {
      showErrorSnackBar(context, 'Fix the highlighted fields and try again.');
      return;
    }
    setState(() => _busy = true);
    try {
      final created = await ref
          .read(complaintsProvider.notifier)
          .submit(
            category: _category!,
            subject: _subject.text,
            description: _description.text,
          );
      if (!mounted) return;
      setState(() {
        _busy = false;
        _submitted = created;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      showErrorSnackBar(context, 'Could not submit just now. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitted = _submitted;
    return PageScaffold(
      title: 'Report an issue',
      showBack: true,
      child: submitted == null ? _form() : _success(submitted),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      autovalidateMode: _showAllErrors
          ? AutovalidateMode.always
          : AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageGutter,
          AppSpacing.lg,
          AppSpacing.pageGutter,
          AppSpacing.xxl,
        ),
        children: [
          Text('Category', style: context.text.label),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final category in ComplaintCategory.values)
                _CategoryChip(
                  category: category,
                  selected: _category == category,
                  onTap: () => setState(() {
                    _category = category;
                    _categoryTouched = true;
                  }),
                ),
            ],
          ),
          if (_categoryTouched && _category == null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Choose a category.',
                style: context.text.meta.copyWith(color: context.colors.danger),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Subject',
            controller: _subject,
            hint: 'A short summary',
            maxLength: 80,
            validator: (v) =>
                FieldRules.length(v, 'Subject', min: 5, max: 80),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Description',
            controller: _description,
            hint: 'What went wrong?',
            maxLines: 6,
            minLines: 4,
            maxLength: 500,
            validator: (v) =>
                FieldRules.length(v, 'Description', min: 20, max: 500),
          ),
          const SizedBox(height: AppSpacing.xl),
          PillButton(
            label: 'Submit complaint',
            icon: Icons.send_outlined,
            expand: true,
            busy: _busy,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  Widget _success(Complaint complaint) {
    final colors = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        AppSpacing.xxl,
        AppSpacing.pageGutter,
        AppSpacing.xxl,
      ),
      children: [
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.pinePale,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, size: 36, color: colors.pine),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Complaint submitted',
          textAlign: TextAlign.center,
          style: context.text.headline,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Our admin team will look into it and get back to you.',
          textAlign: TextAlign.center,
          style: context.text.bodyMuted,
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colors.mist,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            children: [
              Text('Reference ID', style: context.text.label),
              const SizedBox(height: AppSpacing.xs),
              Text(complaint.reference, style: context.text.title),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        PillButton(
          label: 'View my complaints',
          expand: true,
          onPressed: () {
            Navigator.of(context).pop();
            context.push(AppRoutes.myComplaints);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        PillButton(
          label: 'Report another issue',
          variant: PillVariant.quiet,
          expand: true,
          onPressed: () => setState(() {
            _submitted = null;
            _category = null;
            _categoryTouched = false;
            _showAllErrors = false;
            _subject.clear();
            _description.clear();
          }),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final ComplaintCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.pine : colors.mist,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTapTarget,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            category.label,
            style: context.text.chip.copyWith(
              color: selected ? Colors.white : colors.inkMid,
            ),
          ),
        ),
      ),
    );
  }
}
