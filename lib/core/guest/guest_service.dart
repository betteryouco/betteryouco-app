import 'package:dio/dio.dart';

import '../../models/guest_session_response.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';

class GuestService {
  final Dio _dio = ApiClient().dio;

  Future<GuestSessionResponse> createGuestSession() async {
    try {
      final response = await _dio.post(
        '/guest/session',
      );

      return GuestSessionResponse.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.response == null) {
      return ApiException(
        message: 'Unable to connect to server.',
      );
    }

    final data = e.response?.data;

    if (e.response?.statusCode == 422) {
      return ApiException(
        message: data['message'] ?? 'Validation failed',
        statusCode: 422,
        errors: data['errors'],
      );
    }

    return ApiException(
      message: data['message'] ?? 'Something went wrong',
      statusCode: e.response?.statusCode,
    );
  }
}