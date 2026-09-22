import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/app_date.dart';
import '../../../core/models/booking_session.dart';
import '../../bookings/providers/bookings_provider.dart';

// Today already has its own section, so the upcoming list starts from tomorrow.
final upcomingAfterTodayProvider = Provider<List<BookingSession>>((ref) {
  return ref
      .watch(upcomingSessionsProvider)
      .where((session) => !isToday(session.startsAt))
      .toList();
});

enum DayPart { morning, afternoon, evening }

final dayPartProvider = Provider<DayPart>((ref) {
  final hour = DateTime.now().hour;
  if (hour < 12) return DayPart.morning;
  if (hour < 17) return DayPart.afternoon;
  return DayPart.evening;
});
