class ClientListItem {
  final int enrollmentId;
  final String clientName;
  final String programName;
  final int? currentWeek;
  final int? durationWeeks;
  final String? completionStatus;

  const ClientListItem({
    required this.enrollmentId,
    required this.clientName,
    required this.programName,
    this.currentWeek,
    this.durationWeeks,
    this.completionStatus,
  });

  factory ClientListItem.fromJson(Map<String, dynamic> json) {
    return ClientListItem(
      enrollmentId: json['enrollment_id'],
      clientName: json['client_name'] ?? '',
      programName: json['program_name'] ?? '',
      currentWeek: json['current_week'],
      durationWeeks: json['duration_weeks'],
      completionStatus: json['completion_status'],
    );
  }
}
