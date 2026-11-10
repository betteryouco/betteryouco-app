class AssignmentRequestProgram {
  final int id;
  final String title;
  final int? durationWeeks;
  final int? durationWeeksMax;

  const AssignmentRequestProgram({
    required this.id,
    required this.title,
    this.durationWeeks,
    this.durationWeeksMax,
  });

  factory AssignmentRequestProgram.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};
    return AssignmentRequestProgram(
      id: int.tryParse('${data['id']}') ?? 0,
      title: data['title'] ?? 'Program',
      durationWeeks: data['duration_weeks'] != null ? int.tryParse('${data['duration_weeks']}') : null,
      durationWeeksMax: data['duration_weeks_max'] != null ? int.tryParse('${data['duration_weeks_max']}') : null,
    );
  }
}

/// A client purchase matched to this specialist, awaiting their
/// accept/decline response — with the expected-earnings preview shown
/// before they respond (per the onboarding/payment doc's example UI).
class AssignmentRequestModel {
  final int enrollmentId;
  final AssignmentRequestProgram program;
  final double pricePaid;
  final String? currency;
  final int expertSharePercent;
  final double expectedEarnings;

  const AssignmentRequestModel({
    required this.enrollmentId,
    required this.program,
    required this.pricePaid,
    this.currency,
    required this.expertSharePercent,
    required this.expectedEarnings,
  });

  factory AssignmentRequestModel.fromJson(Map<String, dynamic> json) {
    return AssignmentRequestModel(
      enrollmentId: int.tryParse('${json['enrollment_id']}') ?? 0,
      program: AssignmentRequestProgram.fromJson(json['program']),
      pricePaid: double.tryParse('${json['price_paid']}') ?? 0,
      currency: json['currency'],
      expertSharePercent: int.tryParse('${json['expert_share_percent']}') ?? 0,
      expectedEarnings: double.tryParse('${json['expected_earnings']}') ?? 0,
    );
  }
}
