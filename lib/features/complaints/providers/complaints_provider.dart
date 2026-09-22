import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/api_client.dart';
import '../../../core/data/data_providers.dart';
import '../model/complaint.dart';
import '../repository/complaint_repository.dart';

class ComplaintException implements Exception {
  const ComplaintException(this.message);

  final String message;

  @override
  String toString() => message;
}

final complaintRepositoryProvider = Provider<ComplaintRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return api == null
      ? MockComplaintRepository(ref.watch(mockDataSourceProvider))
      : RemoteComplaintRepository(api);
});

class ComplaintsNotifier extends AsyncNotifier<List<Complaint>> {
  static final _random = Random();

  @override
  Future<List<Complaint>> build() {
    return ref.watch(complaintRepositoryProvider).fetchComplaints();
  }

  Future<Complaint> submit({
    required ComplaintCategory category,
    required String subject,
    required String description,
  }) async {
    // Waiting on the initial load keeps a quick submit from failing.
    final current = await future;

    final draft = Complaint(
      id: 'complaint-${DateTime.now().microsecondsSinceEpoch}',
      reference: 'PG-${10000 + _random.nextInt(89999)}',
      category: category,
      subject: subject.trim(),
      description: description.trim(),
      status: ComplaintStatus.open,
      createdAt: DateTime.now(),
    );

    final Complaint created;
    try {
      created = await ref.read(complaintRepositoryProvider).submit(draft);
    } on ApiException catch (e) {
      throw ComplaintException(e.message);
    }
    state = AsyncData([created, ...current]);
    return created;
  }

  void reset() => ref.invalidateSelf();
}

final complaintsProvider =
    AsyncNotifierProvider<ComplaintsNotifier, List<Complaint>>(
      ComplaintsNotifier.new,
    );

final complaintsNewestFirstProvider = Provider<List<Complaint>>((ref) {
  final complaints = ref.watch(complaintsProvider).value ?? const [];
  return [...complaints]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});
