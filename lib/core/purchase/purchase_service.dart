import 'package:dio/dio.dart';

import '../../models/enrollment_model.dart';
import '../../models/payment_model.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';

class PurchaseService {
  final Dio _dio = ApiClient().dio;

  Future<PaymentModel> purchase(int programId) async {
    try {
      final response = await _dio.post(
        "/client/programs/$programId/purchase",
      );

      return PaymentModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PaymentModel> confirmMockPayment(int paymentId) async {
    try {
      final response = await _dio.post(
        "/client/payments/$paymentId/confirm-mock",
      );

      return PaymentModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PaymentModel> renew(int enrollmentId) async {
    try {
      final response = await _dio.post(
        "/client/enrollments/$enrollmentId/renew",
      );

      return PaymentModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<EnrollmentModel>> myEnrollments() async {
    try {
      final response = await _dio.get("/client/enrollments");

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => EnrollmentModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.response == null) {
      return ApiException(message: "Unable to connect to server.");
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
