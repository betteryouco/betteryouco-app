class SleepChartPoint {
  final DateTime time;
  final double value;

  const SleepChartPoint({
    required this.time,
    required this.value,
  });

  factory SleepChartPoint.fromJson(
      Map<String, dynamic> json,
      ) {
    return SleepChartPoint(
      time: DateTime.parse(json["recorded_at"]),
      value: (json["value"] as num).toDouble(),
    );
  }
}
