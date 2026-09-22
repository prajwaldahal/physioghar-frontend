import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/field_rules.dart';
import '../../../../core/models/therapist_profile.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/page_scaffold.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  bool _seeded = false;
  bool _showAllErrors = false;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _seed(TherapistProfile profile) {
    if (_seeded) return;
    _seeded = true;
    _controllers.addAll({
      'name': TextEditingController(text: profile.name),
      'email': TextEditingController(text: profile.email),
      'phone': TextEditingController(text: profile.phone),
      'experience': TextEditingController(text: '${profile.experienceYears}'),
      'specialization': TextEditingController(text: profile.specialization),
      'address': TextEditingController(text: profile.address),
    });
  }

  void _save(TherapistProfile current) {
    // onUserInteraction never reveals errors on fields the user skipped.
    setState(() => _showAllErrors = true);
    if (!(_formKey.currentState?.validate() ?? false)) {
      showErrorSnackBar(context, 'Fix the highlighted fields and try again.');
      return;
    }
    ref
        .read(profileProvider.notifier)
        .save(
          current.copyWith(
            name: _controllers['name']!.text.trim(),
            email: _controllers['email']!.text.trim(),
            phone: _controllers['phone']!.text.trim(),
            experienceYears: int.parse(_controllers['experience']!.text.trim()),
            specialization: _controllers['specialization']!.text.trim(),
            address: _controllers['address']!.text.trim(),
          ),
        );
    Navigator.of(context).pop();
    showSuccessSnackBar(context, 'Profile updated.');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final profile = ref.watch(profileProvider).value;

    if (profile == null) {
      return PageScaffold(
        title: l10n.editProfile,
        showBack: true,
        child: const LoadingView(),
      );
    }
    _seed(profile);

    return PageScaffold(
      title: l10n.editProfile,
      showBack: true,
      child: Form(
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
            AppTextField(
              label: l10n.profileName,
              controller: _controllers['name'],
              textCapitalization: TextCapitalization.words,
              validator: (v) => FieldRules.required(v, l10n.profileName),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.profileEmail,
              controller: _controllers['email'],
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              validator: FieldRules.email,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.profilePhone,
              controller: _controllers['phone'],
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: FieldRules.phone,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.profileExperience,
              controller: _controllers['experience'],
              keyboardType: TextInputType.number,
              maxLength: 2,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => FieldRules.wholeNumber(
                v,
                l10n.profileExperience,
                min: 0,
                max: 60,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.profileSpecialization,
              controller: _controllers['specialization'],
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  FieldRules.required(v, l10n.profileSpecialization),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.profileAddress,
              controller: _controllers['address'],
              maxLines: 2,
              minLines: 1,
              validator: (v) => FieldRules.required(v, l10n.profileAddress),
            ),
            const SizedBox(height: AppSpacing.xl),
            PillButton(
              label: l10n.save,
              icon: Icons.check_rounded,
              expand: true,
              onPressed: () => _save(profile),
            ),
          ],
        ),
      ),
    );
  }
}
