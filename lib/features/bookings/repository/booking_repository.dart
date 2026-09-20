import '../../../core/data/mock_data_source.dart';
import '../../../core/models/booking_session.dart';

abstract class BookingRepository {
  Future<List<BookingSession>> fetchSessions();
}

class MockBookingRepository implements BookingRepository {
  const MockBookingRepository(this._source);

  final MockDataSource _source;

  @override
  Future<List<BookingSession>> fetchSessions() async {
    final rows = await _source.loadList('sessions');
    return rows.map(BookingSession.fromJson).toList();
  }
}
