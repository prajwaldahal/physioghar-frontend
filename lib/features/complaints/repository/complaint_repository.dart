import '../../../core/data/api_client.dart';
import '../../../core/data/mock_data_source.dart';
import '../model/complaint.dart';

abstract class ComplaintRepository {
  Future<List<Complaint>> fetchComplaints();
  Future<Complaint> submit(Complaint draft);
}

class MockComplaintRepository implements ComplaintRepository {
  const MockComplaintRepository(this._source);

  final MockDataSource _source;

  @override
  Future<List<Complaint>> fetchComplaints() async {
    final rows = await _source.loadList('complaints');
    return rows.map(Complaint.fromJson).toList();
  }

  @override
  Future<Complaint> submit(Complaint draft) async {
    // Stands in for the round trip an admin backend would make.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return draft;
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

  @override
  Future<Complaint> submit(Complaint draft) async => Complaint.fromApi(
    await _api.postObject(
      '/api/v1/complaints',
      body: {
        'category': draft.category.name,
        'subject': draft.subject,
        'description': draft.description,
      },
    ),
  );
}
