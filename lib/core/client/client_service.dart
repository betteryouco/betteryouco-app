import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/client_detail_model.dart';
import '../../models/client_model.dart';
import '../../models/health_summary_model.dart';
import '../../models/stress_assessment_dashboard_response.dart';

class ClientService {
  final Dio _dio = ApiClient().dio;

  //---------------------------------------------------
  // Clients List
  //---------------------------------------------------

  Future<List<ClientListItem>> loadClients(String status) async {
    try {
      final response = await _dio.get(
        "/specialist/clients",
        queryParameters: {"status": status},
      );

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => ClientListItem.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Client Detail
  //---------------------------------------------------

  Future<ClientDetailModel> loadClientDetail(int enrollmentId) async {
    try {
      final response = await _dio.get(
        "/specialist/clients/$enrollmentId",
      );

      return ClientDetailModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Client Assessment History
  //---------------------------------------------------

  Future<AssessmentDashboardResponse> loadClientAssessments(
    int enrollmentId,
  ) async {
    try {
      final response = await _dio.get(
        "/specialist/clients/$enrollmentId/assessments",
      );

      return AssessmentDashboardResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Client Vitals History
  //---------------------------------------------------

  Future<HealthSummaryModel> loadClientVitals(int enrollmentId) async {
    try {
      final response = await _dio.get(
        "/specialist/clients/$enrollmentId/vitals",
      );

      return HealthSummaryModel.fromJson(response.data);
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
