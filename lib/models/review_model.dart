class ReviewModel {
  final int id;
  final int rating;
  final String? body;
  final String clientName;
  final DateTime? createdAt;

  const ReviewModel({
    required this.id,
    required this.rating,
    this.body,
    required this.clientName,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      rating: json['rating'],
      body: json['body'],
      clientName: json['client_name'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
