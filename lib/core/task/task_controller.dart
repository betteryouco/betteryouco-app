import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../models/task_request.dart';
import 'task_service.dart';
import 'task_state.dart';

class TaskController extends ChangeNotifier {
  final TaskService _service;

  TaskController(this._service);

  TaskState _state = TaskState.initial();

  TaskState get state => _state;

  void _setState(TaskState state) {
    _state = state;
    notifyListeners();
  }

  //---------------------------------------------------
  // Specialist
  //---------------------------------------------------

  Future<bool> assignTask(int enrollmentId, AssignTaskRequest request) async {
    _setState(_state.copyWith(isAssigning: true, errorMessage: null));

    try {
      await _service.assignTask(enrollmentId, request);

      final tasks = await _service.loadClientTasks(enrollmentId);

      _setState(_state.copyWith(isAssigning: false, clientTasks: tasks));

      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isAssigning: false, errorMessage: e.message));

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isAssigning: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }

  Future<void> loadClientTasks(int enrollmentId) async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final tasks = await _service.loadClientTasks(enrollmentId);

      _setState(_state.copyWith(isLoading: false, clientTasks: tasks));
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  //---------------------------------------------------
  // Client
  //---------------------------------------------------

  Future<void> loadTodayTasks() async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final tasks = await _service.loadTodayTasks();

      _setState(_state.copyWith(isLoading: false, todayTasks: tasks));
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> completeTask(int taskId) async {
    // Optimistic update so the UI feels instant.
    final updated = _state.todayTasks.map((task) {
      if (task.id != taskId) return task;

      return task.copyWith(status: "completed", completedAt: DateTime.now());
    }).toList();

    _setState(_state.copyWith(todayTasks: updated));

    try {
      await _service.completeTask(taskId);
    } on ApiException catch (e) {
      _setState(_state.copyWith(errorMessage: e.message));
      // Re-sync with server state since the optimistic update may be wrong.
      await loadTodayTasks();
    } catch (_) {
      _setState(
        _state.copyWith(
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
