class InstrumentTrendPoint {
  final DateTime date;
  final int score;
  final String? interpretation;

  const InstrumentTrendPoint({
    required this.date,
    required this.score,
    this.interpretation,
  });

  factory InstrumentTrendPoint.fromJson(Map<String, dynamic> json) {
    return InstrumentTrendPoint(
      date: DateTime.tryParse('${json['submitted_at'] ?? json['date']}') ?? DateTime.now(),
      score: int.tryParse('${json['score']}') ?? 0,
      interpretation: json['interpretation'],
    );
  }
}

class InstrumentTrendSeries {
  final int maxScore;
  final List<InstrumentTrendPoint> points;

  const InstrumentTrendSeries({
    required this.maxScore,
    this.points = const [],
  });

  bool get hasData => points.isNotEmpty;

  factory InstrumentTrendSeries.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};
    final rawPoints = (data['points'] as List?) ?? [];

    return InstrumentTrendSeries(
      maxScore: int.tryParse('${data['max_score']}') ?? 0,
      points: rawPoints.map((e) => InstrumentTrendPoint.fromJson(e)).toList(),
    );
  }
}

/// GAD-7/PHQ-8 are genuine single-instrument scores; DASS-21's "points"
/// are the three subscales for a sitting summed into one combined figure
/// (0-126) — see AssessmentService::getInstrumentTrend on the backend.
class InstrumentTrendResponse {
  final InstrumentTrendSeries dass21;
  final InstrumentTrendSeries gad7;
  final InstrumentTrendSeries phq8;

  const InstrumentTrendResponse({
    required this.dass21,
    required this.gad7,
    required this.phq8,
  });

  factory InstrumentTrendResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return InstrumentTrendResponse(
      dass21: InstrumentTrendSeries.fromJson(data['dass21']),
      gad7: InstrumentTrendSeries.fromJson(data['gad7']),
      phq8: InstrumentTrendSeries.fromJson(data['phq8']),
    );
  }

  factory InstrumentTrendResponse.empty() {
    return const InstrumentTrendResponse(
      dass21: InstrumentTrendSeries(maxScore: 126),
      gad7: InstrumentTrendSeries(maxScore: 21),
      phq8: InstrumentTrendSeries(maxScore: 24),
    );
  }
}
