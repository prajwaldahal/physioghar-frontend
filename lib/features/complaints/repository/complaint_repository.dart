import '../../../core/data/api_client.dart';
import '../../../core/data/mock_data_source.dart';
import '../model/complaint.dart';

abstract class ComplaintRepository {
  Future<List<Complaint>> fetchComplaints();
}

class MockComplaintRepository implements ComplaintRepository {
  const MockComplaintRepository(this._source);

  final MockDataSource _source;

  @override
  Future<List<Complaint>> fetchComplaints() async {
    final rows = await _source.loadList('complaints');
    return rows.map(Complaint.fromJson).toList();
  }
}

class RemoteComplaintRepository implements ComplaintRepository {
  const RemoteComplaintRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<Complaint>> fetchComplaints() async {
    final rows = await _api.getList('/api/v1/complaints');
    return rows.map(Complaint.fromApi).toList();
  }
}
