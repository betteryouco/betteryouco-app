import 'program_model.dart';

class EnrollmentSpecialistSummary {
  final int id;
  final String name;

  const EnrollmentSpecialistSummary({required this.id, required this.name});

  factory EnrollmentSpecialistSummary.fromJson(Map<String, dynamic> json) {
    return EnrollmentSpecialistSummary(
      id: json['id'],
      name: json['user']?['name'] ?? 'Specialist',
    );
  }
}

/// Mirrors the assignment_status state machine on the backend:
/// awaiting_payment -> paid -> awaiting_expert -> expert_assigned ->
/// active -> completed / cancelled.
enum AssignmentStatus {
  awaitingPayment,
  paid,
  awaitingExpert,
  expertAssigned,
  active,
  completed,
  cancelled,
  unknown;

  static AssignmentStatus fromJson(String? value) {
    switch (value) {
      case 'awaiting_payment':
        return AssignmentStatus.awaitingPayment;
      case 'paid':
        return AssignmentStatus.paid;
      case 'awaiting_expert':
        return AssignmentStatus.awaitingExpert;
      case 'expert_assigned':
        return AssignmentStatus.expertAssigned;
      case 'active':
        return AssignmentStatus.active;
      case 'completed':
        return AssignmentStatus.completed;
      case 'cancelled':
        return AssignmentStatus.cancelled;
      default:
        return AssignmentStatus.unknown;
    }
  }

  String get label {
    switch (this) {
      case AssignmentStatus.awaitingPayment:
        return 'Awaiting payment';
      case AssignmentStatus.paid:
        return 'Payment received';
      case AssignmentStatus.awaitingExpert:
        return 'Matching you with an expert';
      case AssignmentStatus.expertAssigned:
        return 'Expert assigned — awaiting confirmation';
      case AssignmentStatus.active:
        return 'Active';
      case AssignmentStatus.completed:
        return 'Completed';
      case AssignmentStatus.cancelled:
        return 'Cancelled';
      case AssignmentStatus.unknown:
        return 'Unknown';
    }
  }
}

class EnrollmentModel {
  final int id;
  final int programId;
  final ProgramModel? program;
  final EnrollmentSpecialistSummary? specialist;
  final AssignmentStatus assignmentStatus;
  final double? pricePaid;
  final String? currency;
  final int? revenueShareExpertPercent;
  final DateTime? startedAt;

  const EnrollmentModel({
    required this.id,
    required this.programId,
    this.program,
    this.specialist,
    required this.assignmentStatus,
    this.pricePaid,
    this.currency,
    this.revenueShareExpertPercent,
    this.startedAt,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'],
      programId: json['program_id'],
      program: json['program'] != null
          ? ProgramModel.fromJson(json['program'])
          : null,
      specialist: json['specialist'] != null
          ? EnrollmentSpecialistSummary.fromJson(json['specialist'])
          : null,
      assignmentStatus: AssignmentStatus.fromJson(json['assignment_status']),
      pricePaid: json['price_paid'] != null
          ? double.tryParse('${json['price_paid']}')
          : null,
      currency: json['currency'],
      revenueShareExpertPercent: json['revenue_share_expert_percent'],
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'])
          : null,
    );
  }
}
