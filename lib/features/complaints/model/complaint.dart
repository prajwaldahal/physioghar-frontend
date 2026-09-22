import '../../../core/data/mock_data_source.dart';

enum ComplaintCategory {
  patientIssue,
  bookingIssue,
  paymentIssue,
  technicalIssue,
  other,
}

enum ComplaintStatus { open, resolved }

extension ComplaintCategoryX on ComplaintCategory {
  String get label => switch (this) {
    ComplaintCategory.patientIssue => 'Patient Issue',
    ComplaintCategory.bookingIssue => 'Booking Issue',
    ComplaintCategory.paymentIssue => 'Payment Issue',
    ComplaintCategory.technicalIssue => 'Technical Issue',
    ComplaintCategory.other => 'Other',
  };
}

extension ComplaintStatusX on ComplaintStatus {
  String get label => switch (this) {
    ComplaintStatus.open => 'In review',
    ComplaintStatus.resolved => 'Resolved',
  };
}

class Complaint {
  const Complaint({
    required this.id,
    required this.reference,
    required this.category,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String reference;
  final ComplaintCategory category;
  final String subject;
  final String description;
  final ComplaintStatus status;
  final DateTime createdAt;

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] as String,
      reference: json['reference'] as String,
      category: ComplaintCategory.values.byName(json['category'] as String),
      subject: json['subject'] as String,
      description: json['description'] as String,
      status: ComplaintStatus.values.byName(json['status'] as String),
      createdAt: MockDataSource.resolveDate(
        json['dayOffset'] as int,
        json['time'] as String,
      ),
    );
  }
}
