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
