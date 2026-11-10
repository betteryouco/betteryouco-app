class BookingModel {
  final int id;
  final String? type;
  final DateTime? scheduledAt;
  final int? durationMin;
  final String status;
  final String? videoRoomId;
  final String? clientName;

  const BookingModel({
    required this.id,
    this.type,
    this.scheduledAt,
    this.durationMin,
    required this.status,
    this.videoRoomId,
    this.clientName,
  });

  bool get isPending => status == "pending";

  bool get isScheduled => status == "scheduled";

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      type: json['type'],
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'])
          : null,
      durationMin: json['duration_min'],
      status: json['status'] ?? 'pending',
      videoRoomId: json['video_room_id'],
      clientName: json['client_name'],
    );
  }
}
