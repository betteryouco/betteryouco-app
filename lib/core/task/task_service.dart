import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/client_task_model.dart';
import '../../models/task_request.dart';

class TaskService {
  final Dio _dio = ApiClient().dio;

  //---------------------------------------------------
  // Specialist: Assign Task
  //---------------------------------------------------

  Future<void> assignTask(int enrollmentId, AssignTaskRequest request) async {
    try {
      await _dio.post(
        "/specialist/clients/$enrollmentId/tasks",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Specialist: Client's Assigned Tasks
  //---------------------------------------------------

  Future<List<ClientTaskModel>> loadClientTasks(int enrollmentId) async {
    try {
      final response = await _dio.get(
        "/specialist/clients/$enrollmentId/tasks",
      );

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => ClientTaskModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Client: Today's Tasks
  //---------------------------------------------------

  Future<List<ClientTaskModel>> loadTodayTasks() async {
    try {
      final response = await _dio.get("/client/tasks/today");

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => ClientTaskModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Client: Complete Task
  //---------------------------------------------------

  Future<void> completeTask(int taskId) async {
    try {
      await _dio.post("/client/tasks/$taskId/complete");
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Error Handler
  //---------------------------------------------------

  ApiException _handleError(DioException e) {
    if (e.response == null) {
      return ApiException(
        message: "Unable to connect to server.",
      );
    }

    final data = e.response?.data;

    if (e.response?.statusCode == 422) {
      return ApiException(
        message: data["message"] ?? "Validation failed.",
        statusCode: 422,
        errors: data["errors"],
      );
    }

    return ApiException(
      message: data["message"] ?? "Something went wrong.",
      statusCode: e.response?.statusCode,
    );
  }
}
