import '../../../core/data/mock_data_source.dart';

class SessionNote {
  const SessionNote({
    required this.id,
    required this.patientId,
    required this.note,
    required this.exercises,
    required this.createdAt,
    this.nextSessionPlan,
    this.updatedAt,
  });

  final String id;
  final String patientId;
  final String note;
  final List<String> exercises;
  final String? nextSessionPlan;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get isEdited => updatedAt != null;

  SessionNote copyWith({
    String? note,
    List<String>? exercises,
    String? nextSessionPlan,
    DateTime? updatedAt,
  }) {
    return SessionNote(
      id: id,
      patientId: patientId,
      note: note ?? this.note,
      exercises: exercises ?? this.exercises,
      nextSessionPlan: nextSessionPlan ?? this.nextSessionPlan,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory SessionNote.fromApi(Map<String, dynamic> json) {
    return SessionNote(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      note: json['note'] as String,
      exercises: (json['exercises'] as List<dynamic>).cast<String>(),
      nextSessionPlan: json['nextSessionPlan'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  factory SessionNote.fromJson(Map<String, dynamic> json) {
    return SessionNote(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      note: json['note'] as String,
      exercises: (json['exercises'] as List<dynamic>).cast<String>(),
      nextSessionPlan: json['nextSessionPlan'] as String?,
      createdAt: MockDataSource.resolveDate(
        json['dayOffset'] as int,
        json['time'] as String,
      ),
    );
  }
}
