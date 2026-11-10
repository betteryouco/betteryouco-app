import '../../models/client_task_model.dart';

class TaskState {
  final bool isLoading;
  final bool isAssigning;
  final String? errorMessage;

  final List<ClientTaskModel> clientTasks;
  final List<ClientTaskModel> todayTasks;

  const TaskState({
    this.isLoading = false,
    this.isAssigning = false,
    this.errorMessage,
    this.clientTasks = const [],
    this.todayTasks = const [],
  });

  factory TaskState.initial() {
    return const TaskState();
  }

  TaskState copyWith({
    bool? isLoading,
    bool? isAssigning,
    String? errorMessage,
    List<ClientTaskModel>? clientTasks,
    List<ClientTaskModel>? todayTasks,
  }) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      isAssigning: isAssigning ?? this.isAssigning,
      errorMessage: errorMessage,
      clientTasks: clientTasks ?? this.clientTasks,
      todayTasks: todayTasks ?? this.todayTasks,
    );
  }
}
