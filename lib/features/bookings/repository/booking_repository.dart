import '../../../core/data/api_client.dart';
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

class RemoteBookingRepository implements BookingRepository {
  const RemoteBookingRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<BookingSession>> fetchSessions() async {
    final rows = await _api.getList('/api/v1/bookings');
    return rows.map(BookingSession.fromApi).toList();
  }
}
