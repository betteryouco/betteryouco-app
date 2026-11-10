class MessageModel {
  final int id;
  final int senderId;
  final String? body;
  final DateTime sentAt;
  final DateTime? readAt;

  const MessageModel({
    required this.id,
    required this.senderId,
    this.body,
    required this.sentAt,
    this.readAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: int.tryParse('${json['id']}') ?? 0,
      senderId: int.tryParse('${json['sender_id']}') ?? 0,
      body: json['body'],
      sentAt: DateTime.tryParse('${json['sent_at']}') ?? DateTime.now(),
      readAt: json['read_at'] != null ? DateTime.tryParse('${json['read_at']}') : null,
    );
  }
}
