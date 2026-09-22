enum Gender { female, male, other }

extension GenderX on Gender {
  String get label => switch (this) {
    Gender.female => 'Female',
    Gender.male => 'Male',
    Gender.other => 'Other',
  };
}

class Patient {
  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.condition,
    required this.treatmentHistory,
  });

  final String id;
  final String name;
  final int age;
  final Gender gender;
  final String phone;
  final String condition;
  final List<String> treatmentHistory;

  factory Patient.fromApi(Map<String, dynamic> json) => Patient.fromJson(json);

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: Gender.values.byName(json['gender'] as String),
      phone: json['phone'] as String,
      condition: json['condition'] as String,
      treatmentHistory: (json['treatmentHistory'] as List<dynamic>)
          .cast<String>(),
    );
  }
}
