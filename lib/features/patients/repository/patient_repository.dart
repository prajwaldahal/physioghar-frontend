import '../../../core/data/api_client.dart';
import '../../../core/data/mock_data_source.dart';
import '../../../core/models/patient.dart';
import '../model/session_note.dart';

abstract class PatientRepository {
  Future<List<Patient>> fetchPatients();
}

abstract class NotesRepository {
  Future<List<SessionNote>> fetchNotes();
  Future<SessionNote> add(SessionNote draft);
  Future<SessionNote> edit(SessionNote updated);
}

class MockPatientRepository implements PatientRepository {
  const MockPatientRepository(this._source);

  final MockDataSource _source;

  @override
  Future<List<Patient>> fetchPatients() async {
    final rows = await _source.loadList('patients');
    return rows.map(Patient.fromJson).toList();
  }
}

class MockNotesRepository implements NotesRepository {
  const MockNotesRepository(this._source);

  final MockDataSource _source;

  @override
  Future<List<SessionNote>> fetchNotes() async {
    final rows = await _source.loadList('notes');
    return rows.map(SessionNote.fromJson).toList();
  }

  @override
  Future<SessionNote> add(SessionNote draft) async => draft;

  @override
  Future<SessionNote> edit(SessionNote updated) async => updated;
}

class RemotePatientRepository implements PatientRepository {
  const RemotePatientRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<Patient>> fetchPatients() async {
    final rows = await _api.getList('/api/v1/patients');
    return rows.map(Patient.fromApi).toList();
  }
}

class RemoteNotesRepository implements NotesRepository {
  const RemoteNotesRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<SessionNote>> fetchNotes() async {
    final rows = await _api.getList('/api/v1/notes');
    return rows.map(SessionNote.fromApi).toList();
  }

  @override
  Future<SessionNote> add(SessionNote draft) async => SessionNote.fromApi(
    await _api.postObject(
      '/api/v1/notes',
      body: {
        'patientId': draft.patientId,
        'note': draft.note,
        'exercises': draft.exercises,
        'nextSessionPlan': draft.nextSessionPlan,
      },
    ),
  );

  @override
  Future<SessionNote> edit(SessionNote updated) async => SessionNote.fromApi(
    await _api.putObject(
      '/api/v1/notes/${updated.id}',
      body: {
        'note': updated.note,
        'exercises': updated.exercises,
        'nextSessionPlan': updated.nextSessionPlan,
      },
    ),
  );
}
