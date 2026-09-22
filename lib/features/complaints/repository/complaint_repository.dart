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
