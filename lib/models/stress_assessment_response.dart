class AssessmentResponse {
  final int submissionId;
  final int score;
  final String interpretation;
  final DateTime submittedAt;

  const AssessmentResponse({
    required this.submissionId,
    required this.score,
    required this.interpretation,
    required this.submittedAt,
  });

  factory AssessmentResponse.fromJson(
      Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    return AssessmentResponse(
      submissionId: int.tryParse('${data["id"]}') ?? 0,
      score: int.tryParse('${data["score"]}') ?? 0,
      interpretation: data["interpretation"] ?? "Unclassified",
      submittedAt:
      DateTime.tryParse('${data["submitted_at"]}') ?? DateTime.now(),
    );
  }
}