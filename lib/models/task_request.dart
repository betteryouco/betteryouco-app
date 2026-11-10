class AssignTaskRequest {
  final String title;
  final String? type;
  final String? dueDate;

  const AssignTaskRequest({
    required this.title,
    this.type,
    this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (type != null) 'type': type,
      if (dueDate != null) 'due_date': dueDate,
    };
  }
}
