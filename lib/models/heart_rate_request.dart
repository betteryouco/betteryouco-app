class HeartRateRequest {
  final DateTime recordedAt;
  final int bpm;
  final String source;

  const HeartRateRequest({
    required this.recordedAt,
    required this.bpm,
    this.source = 'manual',
  });

  Map<String, dynamic> toJson() {
    return {
      'recorded_at': recordedAt.toIso8601String(),
      'bpm': bpm,
      'source': source,
    };
  }
}