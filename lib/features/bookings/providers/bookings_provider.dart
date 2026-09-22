import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/data_providers.dart';
import '../../../core/format/app_date.dart';
import '../../../core/models/booking_session.dart';
import '../../schedule/providers/slots_provider.dart';
import '../repository/booking_repository.dart';

class BookingException implements Exception {
  const BookingException(this.message);

  final String message;

  @override
  String toString() => message;
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return api == null
      ? MockBookingRepository(ref.watch(mockDataSourceProvider))
      : RemoteBookingRepository(api);
});

class BookingsNotifier extends AsyncNotifier<List<BookingSession>> {
  @override
  Future<List<BookingSession>> build() {
    return ref.watch(bookingRepositoryProvider).fetchSessions();
  }

  Future<void> accept(String id) async {
    final session = _require(id);
    if (session.status != SessionStatus.pending) {
      throw const BookingException('This request has already been handled.');
    }
    _guardSlotFree(session.startsAt, ignoreSessionId: session.id);
    _replace(session.copyWith(status: SessionStatus.upcoming));
  }

  Future<void> decline(String id) async {
    final session = _require(id);
    if (session.status != SessionStatus.pending) {
      throw const BookingException('This request has already been handled.');
    }
    _replace(session.copyWith(status: SessionStatus.declined));
  }

  Future<void> complete(String id, {String? remarks}) async {
    final session = _require(id);
    if (session.status != SessionStatus.upcoming) {
      throw const BookingException('Only upcoming sessions can be completed.');
    }
    final trimmed = remarks?.trim();
    _replace(
      session.copyWith(
        status: SessionStatus.completed,
        remarks: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      ),
    );
  }

  Future<void> reschedule(String id, DateTime startsAt) async {
    final session = _require(id);
    if (session.status != SessionStatus.upcoming) {
      throw const BookingException('Only upcoming sessions can be moved.');
    }
    if (session.startsAt == startsAt) {
      throw const BookingException(
        'That is the same time this session already has.',
      );
    }
    _guardSlotFree(startsAt, ignoreSessionId: session.id);
    _replace(session.copyWith(startsAt: startsAt));
  }

  void reset() => ref.invalidateSelf();

  void _guardSlotFree(DateTime startsAt, {required String ignoreSessionId}) {
    final clash = _sessions.any(
      (s) =>
          s.id != ignoreSessionId &&
          s.holdsSlot &&
          s.startsAt.isAtSameMomentAs(startsAt),
    );
    if (clash) {
      throw const BookingException(
        'That time is already booked. Pick another slot.',
      );
    }

    // Read rather than watch: the slot list must not become a build dependency,
    // because the schedule derives its booked state from these sessions.
    final slots = ref.read(slotsProvider).value;
    if (slots == null) return;

    final match = slots.where((s) => s.startsAt.isAtSameMomentAs(startsAt));
    if (match.isEmpty) {
      throw const BookingException(
        'There is no slot at that time. Add one from the schedule first.',
      );
    }
    if (match.first.isBlocked) {
      throw const BookingException(
        'That slot is blocked. Unblock it from the schedule or pick another time.',
      );
    }
  }

  List<BookingSession> get _sessions {
    final current = state.value;
    if (current == null) {
      throw const BookingException('Bookings are still loading.');
    }
    return current;
  }

  BookingSession _require(String id) {
    final match = _sessions.where((s) => s.id == id);
    if (match.isEmpty) {
      throw const BookingException('That booking no longer exists.');
    }
    return match.first;
  }

  void _replace(BookingSession session) {
    state = AsyncData([
      for (final s in _sessions)
        if (s.id == session.id) session else s,
    ]);
  }
}

final bookingsProvider =
    AsyncNotifierProvider<BookingsNotifier, List<BookingSession>>(
      BookingsNotifier.new,
    );

List<BookingSession> _sorted(List<BookingSession> sessions, {bool newestFirst = false}) {
  final list = [...sessions]
    ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
  return newestFirst ? list.reversed.toList() : list;
}

final pendingRequestsProvider = Provider<List<BookingSession>>((ref) {
  final sessions = ref.watch(bookingsProvider).value ?? const [];
  return _sorted(
    sessions.where((s) => s.status == SessionStatus.pending).toList(),
  );
});

final upcomingSessionsProvider = Provider<List<BookingSession>>((ref) {
  final sessions = ref.watch(bookingsProvider).value ?? const [];
  return _sorted(
    sessions.where((s) => s.status == SessionStatus.upcoming).toList(),
  );
});

final completedSessionsProvider = Provider<List<BookingSession>>((ref) {
  final sessions = ref.watch(bookingsProvider).value ?? const [];
  return _sorted(
    sessions.where((s) => s.status == SessionStatus.completed).toList(),
    newestFirst: true,
  );
});

final cancelledSessionsProvider = Provider<List<BookingSession>>((ref) {
  final sessions = ref.watch(bookingsProvider).value ?? const [];
  return _sorted(
    sessions.where((s) => s.status.isCancelled).toList(),
    newestFirst: true,
  );
});

final todaySessionsProvider = Provider<List<BookingSession>>((ref) {
  final sessions = ref.watch(bookingsProvider).value ?? const [];
  return _sorted(
    sessions
        .where(
          (s) =>
              isToday(s.startsAt) &&
              (s.status == SessionStatus.upcoming ||
                  s.status == SessionStatus.completed),
        )
        .toList(),
  );
});

final sessionByIdProvider = Provider.family<BookingSession?, String>((ref, id) {
  final sessions = ref.watch(bookingsProvider).value ?? const [];
  final match = sessions.where((s) => s.id == id);
  return match.isEmpty ? null : match.first;
});

// Only genuinely open slots: not blocked, and not already held by a session.
final rescheduleOptionsProvider = Provider.family<List<DateTime>, DateTime>((
  ref,
  date,
) {
  final sessions = ref.watch(bookingsProvider).value ?? const [];
  final taken = sessions
      .where((s) => s.holdsSlot)
      .map((s) => s.startsAt)
      .toSet();
  return ref
      .watch(slotsForDayProvider(date))
      .where((slot) => !slot.isBlocked && !taken.contains(slot.startsAt))
      .map((slot) => slot.startsAt)
      .toList();
});

final sessionsForPatientProvider = Provider.family<List<BookingSession>, String>(
  (ref, patientId) {
    final sessions = ref.watch(bookingsProvider).value ?? const [];
    return _sorted(
      sessions.where((s) => s.patientId == patientId).toList(),
      newestFirst: true,
    );
  },
);
