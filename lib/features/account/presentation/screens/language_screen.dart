import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/page_scaffold.dart';
import '../../../../l10n/generated/app_localizations.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final current = ref.watch(localeProvider).languageCode;

    return PageScaffold(
      title: l10n.languageTitle,
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageGutter,
          AppSpacing.lg,
          AppSpacing.pageGutter,
          AppSpacing.xxl,
        ),
        children: [
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: [
                _Option(
                  label: l10n.languageEnglish,
                  code: 'en',
                  selected: current == 'en',
                ),
                _Option(
                  label: l10n.languageNepali,
                  code: 'ne',
                  selected: current == 'ne',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends ConsumerWidget {
  const _Option({
    required this.label,
    required this.code,
    required this.selected,
  });

  final String label;
  final String code;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(localeProvider.notifier).select(code);
          showSuccessSnackBar(context, 'Language updated.');
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTapTarget + 8,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(child: Text(label, style: context.text.body)),
                if (selected)
                  Icon(
                    Icons.check_circle,
                    size: 20,
                    color: context.colors.pine,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
