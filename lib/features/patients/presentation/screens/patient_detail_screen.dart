import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/patient.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/eyebrow_label.dart';
import '../../../../core/widgets/page_scaffold.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../providers/notes_provider.dart';
import '../../providers/patients_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/note_editor_sheet.dart';

class PatientDetailScreen extends ConsumerWidget {
  const PatientDetailScreen({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(patientByIdProvider(patientId));
    if (patient == null) {
      return const PageScaffold(
        title: 'Patient',
        showBack: true,
        child: EmptyState(
          icon: Icons.search_off,
          title: 'Patient not found',
          message: 'This record is no longer available.',
        ),
      );
    }

    final history = ref.watch(patientHistoryProvider(patientId));
    final notes = ref.watch(notesForPatientProvider(patientId));

    return Scaffold(
      appBar: AppBar(title: const Text('Patient'), actions: const []),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAppSheet<void>(
          context: context,
          builder: (_) => NoteEditorSheet(patientId: patientId),
        ),
        backgroundColor: context.colors.amber,
        foregroundColor: context.colors.ink,
        icon: const Icon(Icons.note_add_outlined),
        label: const Text('Add note'),
      ),
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
                AppSpacing.lg,
                AppSpacing.pageGutter,
                AppSpacing.xxl + AppSpacing.xl,
              ),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          UserAvatar(name: patient.name, size: 52),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient.name,
                                  style: context.text.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  patient.condition,
                                  style: context.text.bodyMuted,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.xl,
                        runSpacing: AppSpacing.md,
                        children: [
                          _Fact(label: 'Age', value: '${patient.age}'),
                          _Fact(
                            label: 'Gender',
                            value: patient.gender.label,
                          ),
                          _Fact(label: 'Contact', value: patient.phone),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const EyebrowLabel('Treatment history'),
                      const SizedBox(height: AppSpacing.sm),
                      for (final entry in patient.treatmentHistory)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Text(
                            '• $entry',
                            style: context.text.bodyMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(
                  title: 'Previous sessions',
                  count: history.length,
                ),
                if (history.isEmpty)
                  const EmptyState(
                    icon: Icons.history,
                    title: 'No completed sessions',
                    message: 'Finished sessions will be listed here.',
                    compact: true,
                  )
                else
                  for (final session in history)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        onTap: () =>
                            context.push(AppRoutes.sessionDetail(session.id)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatFullDate(session.startsAt),
                                    style: context.text.bodyStrong,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${formatTime(session.startsAt)} · '
                                    '${session.treatment}',
                                    style: context.text.meta,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: context.colors.inkMute,
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(title: 'Notes', count: notes.length),
                if (notes.isEmpty)
                  const EmptyState(
                    icon: Icons.sticky_note_2_outlined,
                    title: 'No notes yet',
                    message: 'Add a note after your next session.',
                    compact: true,
                  )
                else
                  for (final note in notes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: NoteCard(
                        note: note,
                        onEdit: () => showAppSheet<void>(
                          context: context,
                          builder: (_) => NoteEditorSheet(
                            patientId: patientId,
                            existing: note,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: context.text.label),
        const SizedBox(height: 2),
        Text(value, style: context.text.bodyStrong),
      ],
    );
  }
}
