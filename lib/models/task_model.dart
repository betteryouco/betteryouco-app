import 'package:flutter/material.dart';

enum TaskStatus {
  pending,
  completed,
}

class TaskModel {
  final int? id;
  final String title;
  final String time;
  final TaskStatus status;

  const TaskModel({
    this.id,
    required this.title,
    required this.time,
    required this.status,
  });

  bool get isCompleted => status == TaskStatus.completed;

  IconData get icon =>
      isCompleted
          ? Icons.check_circle_outline
          : Icons.radio_button_unchecked;

  Color get iconColor =>
      isCompleted
          ? const Color(0xff5A7F38)
          : const Color(0xff263238);
}