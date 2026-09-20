import '../data/mock_data_source.dart';

enum SessionStatus { pending, upcoming, completed, cancelled, declined }

enum SessionLocation { homeVisit, clinic }

extension SessionStatusX on SessionStatus {
  bool get isCancelled =>
      this == SessionStatus.cancelled || this == SessionStatus.declined;

  String get label => switch (this) {
    SessionStatus.pending => 'Pending',
    SessionStatus.upcoming => 'Upcoming',
    SessionStatus.completed => 'Completed',
    SessionStatus.cancelled => 'Cancelled',
    SessionStatus.declined => 'Declined',
  };
}

extension SessionLocationX on SessionLocation {
  String get label => switch (this) {
    SessionLocation.homeVisit => 'Home Visit',
    SessionLocation.clinic => 'Clinic',
  };
}

class BookingSession {
  const BookingSession({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.treatment,
    required this.location,
    required this.startsAt,
    required this.status,
    this.remarks,
  });

  final String id;
  final String patientId;
  final String patientName;
  final String treatment;
  final SessionLocation location;
  final DateTime startsAt;
  final SessionStatus status;
  final String? remarks;

  // Slots are a fixed hour, so a session occupies exactly one slot.
  DateTime get endsAt => startsAt.add(const Duration(hours: 1));

  bool get holdsSlot =>
      status == SessionStatus.upcoming || status == SessionStatus.completed;

  BookingSession copyWith({
    SessionStatus? status,
    DateTime? startsAt,
    String? remarks,
  }) {
    return BookingSession(
      id: id,
      patientId: patientId,
      patientName: patientName,
      treatment: treatment,
      location: location,
      startsAt: startsAt ?? this.startsAt,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
    );
  }

  factory BookingSession.fromJson(Map<String, dynamic> json) {
    return BookingSession(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      treatment: json['treatment'] as String,
      location: SessionLocation.values.byName(json['location'] as String),
      startsAt: MockDataSource.resolveDate(
        json['dayOffset'] as int,
        json['time'] as String,
      ),
      status: SessionStatus.values.byName(json['status'] as String),
      remarks: json['remarks'] as String?,
    );
  }
}
