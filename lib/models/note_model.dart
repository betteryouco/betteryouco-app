class NoteModel {
  final int id;
  final String body;
  final String specialistName;
  final DateTime? createdAt;

  const NoteModel({
    required this.id,
    required this.body,
    required this.specialistName,
    this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      body: json['body'] ?? '',
      specialistName: json['specialist_name'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
