import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../models/blood_pressure_request.dart';
import '../../../models/bmi_request.dart';
import '../../../models/health_response.dart';
import '../../../models/health_summary_model.dart';
import '../../../models/heart_rate_request.dart';
import '../../../models/sleep_request.dart';

class HealthService {
  final Dio _dio = ApiClient().dio;

  ///-------------------------------------------------------
  /// Blood Pressure
  ///-------------------------------------------------------

  Future<HealthResponse> saveBloodPressure(BloodPressureRequest request) async {
    try {
      final response = await _dio.post(
        '/client/health/blood-pressure',
        data: request.toJson(),
      );

      return HealthResponse.fromJson(response.data);
    } on DioException catch (e) {


      throw _handleError(e);
    }
  }

  ///-------------------------------------------------------
  /// Heart Rate
  ///-------------------------------------------------------

  Future<HealthResponse> saveHeartRate(HeartRateRequest request) async {
    try {
      final response = await _dio.post(
        '/client/health/heart-rate',
        data: request.toJson(),
      );

      return HealthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ///-------------------------------------------------------
  /// BMI
  ///-------------------------------------------------------

  Future<HealthResponse> saveBMI(BMIRequest request) async {
    try {
      final response = await _dio.post('/client/health/bmi', data: request.toJson());

      return HealthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ///-------------------------------------------------------
  /// Sleep
  ///-------------------------------------------------------

  Future<HealthResponse> saveSleep(SleepRequest request) async {
    try {
      final response = await _dio.post(
        '/client/health/sleep',
        data: request.toJson(),
      );

      return HealthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<HealthSummaryModel> getSummary(DateTime date) async {
    try {
      final response = await _dio.get(
        "/client/health/summary",

        queryParameters: {"date": DateFormat("yyyy-MM-dd").format(date)},
      );

      return HealthSummaryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ///-------------------------------------------------------
  /// Error Handler
  ///-------------------------------------------------------

  ApiException _handleError(DioException e) {
    if (e.response == null) {
      return ApiException(
        message:
            'Unable to connect to server. Please check your internet connection.',
      );
    }

    final data = e.response?.data;

    switch (e.response?.statusCode) {
      case 400:
        return ApiException(
          message: data['message'] ?? 'Bad request.',
          statusCode: 400,
        );

      case 401:
        return ApiException(
          message: data['message'] ?? 'Unauthorized.',
          statusCode: 401,
        );

      case 403:
        return ApiException(
          message: data['message'] ?? 'Forbidden.',
          statusCode: 403,
        );

      case 404:
        return ApiException(
          message: data['message'] ?? 'Resource not found.',
          statusCode: 404,
        );

      case 422:
        return ApiException(
          message: data['message'] ?? 'Validation failed.',
          statusCode: 422,
          errors: data['errors'],
        );

      case 500:
        return ApiException(
          message: data['message'] ?? 'Internal server error.',
          statusCode: 500,
        );

      default:
        return ApiException(
          message: data['message'] ?? 'Something went wrong.',
          statusCode: e.response?.statusCode,
        );
    }
  }
}
