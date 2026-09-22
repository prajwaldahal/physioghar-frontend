import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../providers/patients_provider.dart';
import '../widgets/patient_tile.dart';

class PatientsListScreen extends ConsumerWidget {
  const PatientsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final patients = ref.watch(patientsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navPatients)),
      body: SafeArea(
        top: false,
        child: switch (patients) {
          AsyncLoading() => const LoadingView(message: 'Loading patients'),
          AsyncError(:final error) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(patientsProvider),
          ),
          AsyncValue(:final value?) when value.isEmpty => const EmptyState(
            icon: Icons.people_outline,
            title: 'No patients yet',
            message: 'Patients appear here once they book a session.',
          ),
          AsyncValue(:final value?) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.contentMaxWidth,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageGutter,
                  AppSpacing.lg,
                  AppSpacing.pageGutter,
                  AppSpacing.xxl,
                ),
                itemCount: value.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final patient = value[index];
                  return PatientTile(
                    patient: patient,
                    onTap: () =>
                        context.push(AppRoutes.patientDetail(patient.id)),
                  );
                },
              ),
            ),
          ),
        },
      ),
    );
  }
}
