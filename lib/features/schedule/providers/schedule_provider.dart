import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/app_date.dart';
import '../../../core/models/availability_slot.dart';
import '../../../core/models/booking_session.dart';
import '../../bookings/providers/bookings_provider.dart';
import 'slots_provider.dart';

class ResolvedSlot {
  const ResolvedSlot({required this.slot, required this.state, this.session});

  final AvailabilitySlot slot;
  final SlotState state;
  final BookingSession? session;

  DateTime get startsAt => slot.startsAt;
}

class SelectedScheduleDate extends Notifier<DateTime> {
  @override
  DateTime build() => dateOnly(DateTime.now());

  void select(DateTime date) => state = dateOnly(date);
}

final selectedScheduleDateProvider =
    NotifierProvider<SelectedScheduleDate, DateTime>(SelectedScheduleDate.new);

final scheduleWeekProvider = Provider<List<DateTime>>(
  (ref) => weekOf(DateTime.now()),
);

// BOOKED is derived here and never stored, so a session and its slot can
// never disagree.
final daySlotsProvider = Provider.family<List<ResolvedSlot>, DateTime>((
  ref,
  date,
) {
  final slots = ref.watch(slotsForDayProvider(date));
  final sessions = ref.watch(bookingsProvider).value ?? const [];
  final holders = {
    for (final session in sessions)
      if (session.holdsSlot) session.startsAt: session,
  };

  return [
    for (final slot in slots)
      if (holders[slot.startsAt] case final session?)
        ResolvedSlot(slot: slot, state: SlotState.booked, session: session)
      else
        ResolvedSlot(
          slot: slot,
          state: slot.isBlocked ? SlotState.blocked : SlotState.open,
        ),
  ];
});

final dayOpenCountProvider = Provider.family<int, DateTime>((ref, date) {
  return ref
      .watch(daySlotsProvider(date))
      .where((s) => s.state == SlotState.open)
      .length;
});

class AvailabilityStatusNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void setAvailable(bool value) => state = value;

  void toggle() => state = !state;
}

final availabilityStatusProvider =
    NotifierProvider<AvailabilityStatusNotifier, bool>(
      AvailabilityStatusNotifier.new,
    );
