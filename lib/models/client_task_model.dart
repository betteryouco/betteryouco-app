class ClientTaskModel {
  final int id;
  final String title;
  final String? type;
  final String? dueDate;
  final String status;
  final DateTime? completedAt;

  const ClientTaskModel({
    required this.id,
    required this.title,
    this.type,
    this.dueDate,
    required this.status,
    this.completedAt,
  });

  bool get isCompleted => status == "completed";

  ClientTaskModel copyWith({String? status, DateTime? completedAt}) {
    return ClientTaskModel(
      id: id,
      title: title,
      type: type,
      dueDate: dueDate,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory ClientTaskModel.fromJson(Map<String, dynamic> json) {
    return ClientTaskModel(
      id: json['id'],
      title: json['title'] ?? '',
      type: json['type'],
      dueDate: json['due_date'],
      status: json['status'] ?? 'pending',
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
    );
  }
}
