import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../bookings/providers/bookings_provider.dart';
import '../../../schedule/providers/schedule_provider.dart';
import '../../../schedule/providers/slots_provider.dart';
import '../../providers/profile_provider.dart';
import '../widgets/account_menu_tile.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final profile = ref.watch(profileProvider).value;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.contentMaxWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                AppSpacing.md,
                AppSpacing.pageGutter,
                AppSpacing.xxl,
              ),
              children: [
                AppCard(
                  child: Row(
                    children: [
                      UserAvatar(name: profile?.name ?? '?', size: 52),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.name ?? 'Loading…',
                              style: context.text.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile?.specialization ?? '',
                              style: context.text.bodyMuted,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Column(
                    children: [
                      AccountMenuTile(
                        icon: Icons.person_outline,
                        label: l10n.myProfile,
                        onTap: () => context.push(AppRoutes.myProfile),
                      ),
                      AccountMenuTile(
                        icon: Icons.edit_outlined,
                        label: l10n.editProfile,
                        onTap: () => context.push(AppRoutes.editProfile),
                      ),
                      AccountMenuTile(
                        icon: Icons.event_available_outlined,
                        label: l10n.availabilityStatus,
                        trailing: ref.watch(availabilityStatusProvider)
                            ? l10n.available
                            : l10n.unavailable,
                        onTap: () => context.go(AppRoutes.schedule),
                      ),
                      AccountMenuTile(
                        icon: Icons.language_outlined,
                        label: l10n.languageTitle,
                        trailing: locale.languageCode == 'ne'
                            ? l10n.languageNepali
                            : l10n.languageEnglish,
                        onTap: () => context.push(AppRoutes.language),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: AccountMenuTile(
                    icon: Icons.logout,
                    label: l10n.logout,
                    destructive: true,
                    onTap: () => _logout(context, ref, l10n),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logout(
    BuildContext context,
    WidgetRef ref,
    AppL10n l10n,
  ) async {
    final confirmed = await confirmAction(
      context,
      title: l10n.logoutConfirmTitle,
      message: l10n.logoutConfirmMessage,
      confirmLabel: l10n.logout,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed || !context.mounted) return;

    // No real auth: logging out just puts the mock data back to its seed.
    ref.read(bookingsProvider.notifier).reset();
    ref.read(slotsProvider.notifier).reset();
    ref.read(profileProvider.notifier).reset();
    ref.read(availabilityStatusProvider.notifier).setAvailable(true);
    ref.read(localeProvider.notifier).select('en');

    if (!context.mounted) return;
    context.go(AppRoutes.dashboard);
    showSuccessSnackBar(context, 'Logged out. Demo data has been reset.');
  }
}
