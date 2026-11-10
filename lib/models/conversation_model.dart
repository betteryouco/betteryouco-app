class ConversationSummary {
  final int conversationId;
  final String name;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final bool unread;

  const ConversationSummary({
    required this.conversationId,
    required this.name,
    this.lastMessage,
    this.lastMessageAt,
    this.unread = false,
  });

  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      conversationId: json['conversation_id'],
      name: json['name'] ?? '',
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.tryParse(json['last_message_at'])
          : null,
      unread: json['unread'] ?? false,
    );
  }
}
