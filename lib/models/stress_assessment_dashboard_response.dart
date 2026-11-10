

class AssessmentDashboardResponse {
  final LatestAssessment? latest;
  final List<AssessmentHistoryItem> history;

  const AssessmentDashboardResponse({
    required this.latest,
    required this.history,
  });

  factory AssessmentDashboardResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final data = json['data'];

    return AssessmentDashboardResponse(
      latest: data['latest'] != null
          ? LatestAssessment.fromJson(data['latest'])
          : null,
      history: (data['history'] as List)
          .map(
            (e) => AssessmentHistoryItem.fromJson(e),
      )
          .toList(),
    );
  }
}


class LatestAssessment {
  final int id;
  final int score;
  final String interpretation;
  final DateTime submittedAt;

  const LatestAssessment({
    required this.id,
    required this.score,
    required this.interpretation,
    required this.submittedAt,
  });

  factory LatestAssessment.fromJson(
      Map<String, dynamic> json,
      ) {
    return LatestAssessment(
      id: json['id'],
      score: json['score'],
      interpretation: json['interpretation'],
      submittedAt: DateTime.parse(
        json['submitted_at'],
      ),
    );
  }
}

class AssessmentHistoryItem {
  final int id;
  final int score;
  final String interpretation;
  final DateTime submittedAt;
  final String date;

  const AssessmentHistoryItem({
    required this.id,
    required this.score,
    required this.interpretation,
    required this.submittedAt,
    required this.date,
  });

  factory AssessmentHistoryItem.fromJson(
      Map<String, dynamic> json,
      ) {
    return AssessmentHistoryItem(
      id: json['id'],
      score: json['score'],
      interpretation: json['interpretation'],
      submittedAt: DateTime.parse(
        json['submitted_at'],
      ),
      date: json['date'],
    );
  }
}