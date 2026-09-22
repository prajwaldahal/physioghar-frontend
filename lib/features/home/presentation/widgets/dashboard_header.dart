import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/eyebrow_label.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../account/providers/profile_provider.dart';
import '../../../schedule/presentation/widgets/availability_toggle.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final colors = context.colors;
    final name = ref.watch(therapistNameProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: colors.heroGradient,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageGutter,
            AppSpacing.lg,
            AppSpacing.pageGutter,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EyebrowLabel(
                          formatLongDate(DateTime.now()),
                          color: Colors.white70,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          name.isEmpty ? '' : l10n.greeting(name),
                          style: context.text.headline.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  if (name.isNotEmpty)
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () => context.push(AppRoutes.myProfile),
                        customBorder: const CircleBorder(),
                        child: UserAvatar(
                          name: name,
                          size: 48,
                          background: Colors.white24,
                          foreground: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const AvailabilityToggle(onDark: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
