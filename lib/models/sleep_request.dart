class SleepRequest {
  final DateTime startsAt;
  final DateTime endsAt;
  final String source;

  const SleepRequest({
    required this.startsAt,
    required this.endsAt,
    this.source = 'manual',
  });

  Map<String, dynamic> toJson() {
    return {
      'starts_at': startsAt.toIso8601String(),
      'ends_at': endsAt.toIso8601String(),
      'source': source,
    };
  }
}
