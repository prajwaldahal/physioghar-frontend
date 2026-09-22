import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/page_scaffold.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../widgets/profile_field_row.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final profile = ref.watch(profileProvider);

    return PageScaffold(
      title: l10n.myProfile,
      showBack: true,
      child: switch (profile) {
        AsyncLoading() => const LoadingView(),
        AsyncError(:final error) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(profileProvider),
        ),
        AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageGutter,
            AppSpacing.lg,
            AppSpacing.pageGutter,
            AppSpacing.xxl,
          ),
          children: [
            Center(
              child: Column(
                children: [
                  UserAvatar(name: value.name, size: 84),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    value.name,
                    style: context.text.headline,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value.specialization,
                    style: context.text.bodyMuted,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Column(
                children: [
                  ProfileFieldRow(
                    icon: Icons.mail_outline,
                    label: l10n.profileEmail,
                    value: value.email,
                  ),
                  ProfileFieldRow(
                    icon: Icons.phone_outlined,
                    label: l10n.profilePhone,
                    value: value.phone,
                  ),
                  ProfileFieldRow(
                    icon: Icons.workspace_premium_outlined,
                    label: l10n.profileExperience,
                    value: l10n.yearsExperience(value.experienceYears),
                  ),
                  ProfileFieldRow(
                    icon: Icons.medical_services_outlined,
                    label: l10n.profileSpecialization,
                    value: value.specialization,
                  ),
                  ProfileFieldRow(
                    icon: Icons.location_on_outlined,
                    label: l10n.profileAddress,
                    value: value.address,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PillButton(
              label: l10n.editProfile,
              icon: Icons.edit_outlined,
              expand: true,
              onPressed: () => context.push(AppRoutes.editProfile),
            ),
          ],
        ),
      },
    );
  }
}
