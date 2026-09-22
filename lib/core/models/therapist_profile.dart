class TherapistProfile {
  const TherapistProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.experienceYears,
    required this.specialization,
    required this.address,
  });

  final String name;
  final String email;
  final String phone;
  final int experienceYears;
  final String specialization;
  final String address;

  TherapistProfile copyWith({
    String? name,
    String? email,
    String? phone,
    int? experienceYears,
    String? specialization,
    String? address,
  }) {
    return TherapistProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      experienceYears: experienceYears ?? this.experienceYears,
      specialization: specialization ?? this.specialization,
      address: address ?? this.address,
    );
  }

  factory TherapistProfile.fromApi(Map<String, dynamic> json) =>
      TherapistProfile.fromJson(json);

  factory TherapistProfile.fromJson(Map<String, dynamic> json) {
    return TherapistProfile(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      experienceYears: json['experienceYears'] as int,
      specialization: json['specialization'] as String,
      address: json['address'] as String,
    );
  }
}
