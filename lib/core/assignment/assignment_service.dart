import 'package:dio/dio.dart';

import '../../models/assignment_request_model.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';

class AssignmentService {
  final Dio _dio = ApiClient().dio;

  Future<List<AssignmentRequestModel>> pending() async {
    try {
      final response = await _dio.get("/specialist/assignments/pending");

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => AssignmentRequestModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> accept(int enrollmentId) async {
    try {
      await _dio.post("/specialist/assignments/$enrollmentId/accept");
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> decline(int enrollmentId) async {
    try {
      await _dio.post("/specialist/assignments/$enrollmentId/decline");
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.response == null) {
      return ApiException(message: "Unable to connect to server.");
    }

    final data = e.response?.data;

    return ApiException(
      message: data["message"] ?? "Something went wrong.",
      statusCode: e.response?.statusCode,
    );
  }
}
