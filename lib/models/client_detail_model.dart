class ClientDetailModel {
  final int enrollmentId;
  final String clientName;
  final String? email;
  final String? gender;
  final int? age;
  final String programName;
  final int? currentWeek;
  final int? durationWeeks;
  final DateTime? startedAt;
  final DateTime? endsAt;
  final String? completionStatus;

  const ClientDetailModel({
    required this.enrollmentId,
    required this.clientName,
    this.email,
    this.gender,
    this.age,
    required this.programName,
    this.currentWeek,
    this.durationWeeks,
    this.startedAt,
    this.endsAt,
    this.completionStatus,
  });

  factory ClientDetailModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailModel(
      enrollmentId: json['enrollment_id'],
      clientName: json['client_name'] ?? '',
      email: json['email'],
      gender: json['gender'],
      age: json['age'],
      programName: json['program_name'] ?? '',
      currentWeek: json['current_week'],
      durationWeeks: json['duration_weeks'],
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'])
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'])
          : null,
      completionStatus: json['completion_status'],
    );
  }
}
