import '../../../core/data/api_client.dart';
import '../../../core/data/mock_data_source.dart';
import '../../../core/models/patient.dart';
import '../model/session_note.dart';

abstract class PatientRepository {
  Future<List<Patient>> fetchPatients();
}

abstract class NotesRepository {
  Future<List<SessionNote>> fetchNotes();
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
}
