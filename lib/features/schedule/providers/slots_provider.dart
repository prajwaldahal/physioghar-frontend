import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/api_client.dart';
import '../../../core/data/data_providers.dart';
import '../../../core/format/app_date.dart';
import '../../../core/models/availability_slot.dart';
import '../repository/slot_repository.dart';

class ScheduleException implements Exception {
  const ScheduleException(this.message);

  final String message;

  @override
  String toString() => message;
}

final slotRepositoryProvider = Provider<SlotRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return api == null
      ? MockSlotRepository(ref.watch(mockDataSourceProvider))
      : RemoteSlotRepository(api);
});

// Holds only what the therapist controls: open or blocked. Whether a slot is
// booked is derived from sessions, never stored here.
class SlotsNotifier extends AsyncNotifier<List<AvailabilitySlot>> {
  @override
  Future<List<AvailabilitySlot>> build() {
    return ref.watch(slotRepositoryProvider).fetchSlots();
  }

  Future<void> block(String id) async {
    final slot = _require(id);
    if (slot.isBlocked) {
      throw const ScheduleException('That slot is already blocked.');
    }
    _replace(await _send((repo) => repo.block(slot)));
  }

  Future<void> unblock(String id) async {
    final slot = _require(id);
    if (!slot.isBlocked) {
      throw const ScheduleException('That slot is already open.');
    }
    _replace(await _send((repo) => repo.unblock(slot)));
  }

  Future<void> addSlot(DateTime startsAt) async {
    final slots = _slots;
    if (slots.any((s) => s.overlaps(startsAt))) {
      throw const ScheduleException(
        'That overlaps a slot you already have on this day.',
      );
    }
    final added = await _send((repo) => repo.addSlot(startsAt));
    state = AsyncData(
      [...slots, added]..sort((a, b) => a.startsAt.compareTo(b.startsAt)),
    );
  }

  Future<AvailabilitySlot> _send(
    Future<AvailabilitySlot> Function(SlotRepository) action,
  ) async {
    try {
      return await action(ref.read(slotRepositoryProvider));
    } on ApiException catch (e) {
      throw ScheduleException(e.message);
    }
  }

  void reset() => ref.invalidateSelf();

  List<AvailabilitySlot> get _slots {
    final current = state.value;
    if (current == null) {
      throw const ScheduleException('The schedule is still loading.');
    }
    return current;
  }

  AvailabilitySlot _require(String id) {
    final match = _slots.where((s) => s.id == id);
    if (match.isEmpty) {
      throw const ScheduleException('That slot no longer exists.');
    }
    return match.first;
  }

  void _replace(AvailabilitySlot slot) {
    state = AsyncData([
      for (final s in _slots)
        if (s.id == slot.id) slot else s,
    ]);
  }
}

final slotsProvider =
    AsyncNotifierProvider<SlotsNotifier, List<AvailabilitySlot>>(
      SlotsNotifier.new,
    );

final slotsForDayProvider = Provider.family<List<AvailabilitySlot>, DateTime>((
  ref,
  date,
) {
  final slots = ref.watch(slotsProvider).value ?? const [];
  return slots.where((s) => isSameDay(s.startsAt, date)).toList()
    ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
});
