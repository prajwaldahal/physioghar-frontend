import '../../../core/data/mock_data_source.dart';
import '../../../core/format/app_date.dart';
import '../../../core/models/availability_slot.dart';

abstract class SlotRepository {
  Future<List<AvailabilitySlot>> fetchSlots();
}

class MockSlotRepository implements SlotRepository {
  const MockSlotRepository(this._source);

  final MockDataSource _source;

  // Seeded from a weekday template rather than fixed dates, so the week looks
  // the same whichever day the app is opened.
  @override
  Future<List<AvailabilitySlot>> fetchSlots() async {
    final config = await _source.loadObject('slots');
    final hours = (config['hours'] as List<dynamic>).cast<String>();
    final horizon = config['horizonDays'] as int;
    final weekdays = config['weekdays'] as Map<String, dynamic>;

    final start = startOfWeek(DateTime.now());
    final slots = <AvailabilitySlot>[];

    for (var day = 0; day < horizon; day++) {
      final date = start.add(Duration(days: day));
      final template = weekdays['${date.weekday}'] as Map<String, dynamic>;
      final blocked = (template['blocked'] as List<dynamic>).cast<String>();
      final skipped = (template['skip'] as List<dynamic>).cast<String>();

      for (final hour in hours) {
        if (skipped.contains(hour)) continue;
        final parts = hour.split(':');
        slots.add(
          AvailabilitySlot(
            id: '${date.year}${date.month}${date.day}-$hour',
            startsAt: DateTime(
              date.year,
              date.month,
              date.day,
              int.parse(parts.first),
              int.parse(parts.last),
            ),
            availability: blocked.contains(hour)
                ? SlotAvailability.blocked
                : SlotAvailability.open,
          ),
        );
      }
    }
    return slots;
  }
}
