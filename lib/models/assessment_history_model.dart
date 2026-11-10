class AssessmentHistoryPoint {
  final int score;
  final String interpretation;
  final DateTime submittedAt;

  const AssessmentHistoryPoint({
    required this.score,
    required this.interpretation,
    required this.submittedAt,
  });

  factory AssessmentHistoryPoint.fromJson(Map<String, dynamic> json) {
    return AssessmentHistoryPoint(
      score: json['score'],
      interpretation: json['interpretation'] ?? '',
      submittedAt: DateTime.parse(json['submitted_at']),
    );
  }
}

class AssessmentHistoryResponse {
  final AssessmentHistoryPoint? baseline;
  final AssessmentHistoryPoint? current;
  final double? percentChange;
  final List<AssessmentHistoryPoint> history;

  const AssessmentHistoryResponse({
    this.baseline,
    this.current,
    this.percentChange,
    this.history = const [],
  });

  factory AssessmentHistoryResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AssessmentHistoryResponse(
      baseline: data['baseline'] != null
          ? AssessmentHistoryPoint.fromJson(data['baseline'])
          : null,
      current: data['current'] != null
          ? AssessmentHistoryPoint.fromJson(data['current'])
          : null,
      percentChange: data['percent_change'] != null
          ? double.tryParse(data['percent_change'].toString())
          : null,
      history: (data['history'] as List? ?? [])
          .map((e) => AssessmentHistoryPoint.fromJson(e))
          .toList(),
    );
  }
}
