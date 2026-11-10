import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/review_model.dart';

class ReviewService {
  final Dio _dio = ApiClient().dio;

  Future<List<ReviewModel>> loadReviews(int specialistId) async {
    try {
      final response = await _dio.get(
        "/client/specialists/$specialistId/reviews",
      );

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => ReviewModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ReviewModel> submitReview({
    required int specialistId,
    required int rating,
    String? body,
  }) async {
    try {
      final response = await _dio.post(
        "/client/specialists/$specialistId/reviews",
        data: {"rating": rating, if (body != null && body.isNotEmpty) "body": body},
      );

      return ReviewModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

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
