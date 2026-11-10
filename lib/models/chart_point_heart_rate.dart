class HeartRateChartPoint {
  final DateTime time;
  final double value;

  const HeartRateChartPoint({
    required this.time,
    required this.value,
  });

  factory HeartRateChartPoint.fromJson(
      Map<String, dynamic> json,
      ) {
    return HeartRateChartPoint(
      time: DateTime.parse(json["recorded_at"]),
      value: (json["value"] as num).toDouble(),
    );
  }
}