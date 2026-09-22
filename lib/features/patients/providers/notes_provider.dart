import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/data_providers.dart';
import '../model/session_note.dart';
import '../repository/patient_repository.dart';

class NoteException implements Exception {
  const NoteException(this.message);

  final String message;

  @override
  String toString() => message;
}

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return api == null
      ? MockNotesRepository(ref.watch(mockDataSourceProvider))
      : RemoteNotesRepository(api);
});

class NotesNotifier extends AsyncNotifier<List<SessionNote>> {
  @override
  Future<List<SessionNote>> build() {
    return ref.watch(notesRepositoryProvider).fetchNotes();
  }

  Future<void> add({
    required String patientId,
    required String note,
    required List<String> exercises,
    String? nextSessionPlan,
  }) async {
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      throw const NoteException('A session note is required.');
    }
    final created = SessionNote(
      id: 'note-${DateTime.now().microsecondsSinceEpoch}',
      patientId: patientId,
      note: trimmed,
      exercises: _clean(exercises),
      nextSessionPlan: _optional(nextSessionPlan),
      createdAt: DateTime.now(),
    );
    state = AsyncData([...(_notes), created]);
  }

  Future<void> edit({
    required String id,
    required String note,
    required List<String> exercises,
    String? nextSessionPlan,
  }) async {
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      throw const NoteException('A session note is required.');
    }
    final existing = _notes.where((n) => n.id == id);
    if (existing.isEmpty) {
      throw const NoteException('That note no longer exists.');
    }
    final updated = existing.first.copyWith(
      note: trimmed,
      exercises: _clean(exercises),
      nextSessionPlan: _optional(nextSessionPlan),
      updatedAt: DateTime.now(),
    );
    state = AsyncData([
      for (final n in _notes)
        if (n.id == id) updated else n,
    ]);
  }

  void reset() => ref.invalidateSelf();

  List<String> _clean(List<String> values) => [
    for (final value in values)
      if (value.trim().isNotEmpty) value.trim(),
  ];

  String? _optional(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  List<SessionNote> get _notes {
    final current = state.value;
    if (current == null) {
      throw const NoteException('Notes are still loading.');
    }
    return current;
  }
}

final notesProvider =
    AsyncNotifierProvider<NotesNotifier, List<SessionNote>>(
      NotesNotifier.new,
    );

final notesForPatientProvider = Provider.family<List<SessionNote>, String>((
  ref,
  patientId,
) {
  final notes = ref.watch(notesProvider).value ?? const [];
  return notes.where((n) => n.patientId == patientId).toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});
