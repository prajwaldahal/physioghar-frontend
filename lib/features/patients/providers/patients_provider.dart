import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/data_providers.dart';
import '../../../core/models/booking_session.dart';
import '../../../core/models/patient.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../repository/patient_repository.dart';

final patientRepositoryProvider = Provider<PatientRepository>(
  (ref) => MockPatientRepository(ref.watch(mockDataSourceProvider)),
);

class PatientsNotifier extends AsyncNotifier<List<Patient>> {
  @override
  Future<List<Patient>> build() {
    return ref.watch(patientRepositoryProvider).fetchPatients();
  }
}

final patientsProvider =
    AsyncNotifierProvider<PatientsNotifier, List<Patient>>(
      PatientsNotifier.new,
    );

final patientByIdProvider = Provider.family<Patient?, String>((ref, id) {
  final patients = ref.watch(patientsProvider).value ?? const [];
  final match = patients.where((p) => p.id == id);
  return match.isEmpty ? null : match.first;
});

// Derived from sessions so a completed session immediately moves the date.
final lastSessionDateProvider = Provider.family<DateTime?, String>((
  ref,
  patientId,
) {
  final completed = ref
      .watch(sessionsForPatientProvider(patientId))
      .where((s) => s.status == SessionStatus.completed);
  return completed.isEmpty ? null : completed.first.startsAt;
});

final patientHistoryProvider = Provider.family<List<BookingSession>, String>((
  ref,
  patientId,
) {
  return ref
      .watch(sessionsForPatientProvider(patientId))
      .where((s) => s.status == SessionStatus.completed)
      .toList();
});
