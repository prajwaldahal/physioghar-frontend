import '../../../core/data/api_client.dart';
import '../../../core/data/mock_data_source.dart';
import '../../../core/models/booking_session.dart';

abstract class BookingRepository {
  Future<List<BookingSession>> fetchSessions();
  Future<BookingSession> accept(BookingSession session);
  Future<BookingSession> decline(BookingSession session);
  Future<BookingSession> complete(BookingSession session, String? remarks);
  Future<BookingSession> reschedule(BookingSession session, DateTime startsAt);
}

class MockBookingRepository implements BookingRepository {
  const MockBookingRepository(this._source);

  final MockDataSource _source;

  @override
  Future<List<BookingSession>> fetchSessions() async {
    final rows = await _source.loadList('sessions');
    return rows.map(BookingSession.fromJson).toList();
  }

  @override
  Future<BookingSession> accept(BookingSession session) async =>
      session.copyWith(status: SessionStatus.upcoming);

  @override
  Future<BookingSession> decline(BookingSession session) async =>
      session.copyWith(status: SessionStatus.declined);

  @override
  Future<BookingSession> complete(
    BookingSession session,
    String? remarks,
  ) async => session.copyWith(
    status: SessionStatus.completed,
    remarks: remarks,
    clearRemarks: remarks == null,
  );

  @override
  Future<BookingSession> reschedule(
    BookingSession session,
    DateTime startsAt,
  ) async => session.copyWith(startsAt: startsAt);
}

class RemoteBookingRepository implements BookingRepository {
  const RemoteBookingRepository(this._api);

  final ApiClient _api;

  static String _path(String id, String action) =>
      '/api/v1/bookings/$id/$action';

  @override
  Future<List<BookingSession>> fetchSessions() async {
    final rows = await _api.getList('/api/v1/bookings');
    return rows.map(BookingSession.fromApi).toList();
  }

  @override
  Future<BookingSession> accept(BookingSession session) async =>
      BookingSession.fromApi(await _api.postObject(_path(session.id, 'accept')));

  @override
  Future<BookingSession> decline(BookingSession session) async =>
      BookingSession.fromApi(
        await _api.postObject(_path(session.id, 'decline')),
      );

  @override
  Future<BookingSession> complete(
    BookingSession session,
    String? remarks,
  ) async => BookingSession.fromApi(
    await _api.postObject(
      _path(session.id, 'complete'),
      body: {'remarks': remarks},
    ),
  );

  @override
  Future<BookingSession> reschedule(
    BookingSession session,
    DateTime startsAt,
  ) async => BookingSession.fromApi(
    await _api.postObject(
      _path(session.id, 'reschedule'),
      body: {'startsAt': startsAt.toIso8601String()},
    ),
  );
}
