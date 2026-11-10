class BMIRequest {
  final DateTime recordedAt;
  final double height;
  final double weight;
  final String source;

  const BMIRequest({
    required this.recordedAt,
    required this.height,
    required this.weight,
    this.source = 'manual',
  });

  double get bmi =>
      weight / ((height / 100) * (height / 100));

  Map<String, dynamic> toJson() {
    return {
      'recorded_at': recordedAt.toIso8601String(),
      'height': height,
      'weight': weight,
      'source': source,
    };
  }
}