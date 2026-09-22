enum SlotAvailability { open, blocked }

enum SlotState { open, booked, blocked }

extension SlotStateX on SlotState {
  String get label => switch (this) {
    SlotState.open => 'Open',
    SlotState.booked => 'Booked',
    SlotState.blocked => 'Blocked',
  };
}

class AvailabilitySlot {
  const AvailabilitySlot({
    required this.id,
    required this.startsAt,
    required this.availability,
  });

  final String id;
  final DateTime startsAt;
  final SlotAvailability availability;

  static const duration = Duration(hours: 1);

  DateTime get endsAt => startsAt.add(duration);

  bool get isBlocked => availability == SlotAvailability.blocked;

  bool overlaps(DateTime otherStart) {
    final otherEnd = otherStart.add(duration);
    return startsAt.isBefore(otherEnd) && otherStart.isBefore(endsAt);
  }

  factory AvailabilitySlot.fromApi(Map<String, dynamic> json) {
    return AvailabilitySlot(
      id: json['id'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      availability: json['state'] == 'blocked'
          ? SlotAvailability.blocked
          : SlotAvailability.open,
    );
  }

  AvailabilitySlot copyWith({SlotAvailability? availability}) {
    return AvailabilitySlot(
      id: id,
      startsAt: startsAt,
      availability: availability ?? this.availability,
    );
  }
}
