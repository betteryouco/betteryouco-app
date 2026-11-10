import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../models/assessment_history_model.dart';
import '../../../models/instrument_trend_response.dart';
import '../../../models/stress_assessment_dashboard_response.dart';
import '../../../models/stress_assessment_request.dart';
import '../../../models/stress_assessment_response.dart';
import '../../auth/guest_session_manager.dart';
import '../../auth/session_manager.dart';
import '../../network/api_client.dart';
import '../../network/api_exception.dart';

class AssessmentService {
  final Dio _dio = ApiClient().dio;

  Future<AssessmentResponse> submitAssessment(
    StressAssessmentRequest request,
  ) async {
    try {
      return await _submitOnce(request);
    } on ApiException catch (e) {
      // A cached guest_session_token can go stale (its guest_sessions
      // row no longer exists — most commonly after the backend database
      // was reset/reseeded during development, but the same class of
      // failure can happen in production if a session ever expires
      // server-side while still cached on-device). Rather than leaving
      // the user stuck on a dead "See My Results" button, recover
      // silently: mint a fresh guest session and retry exactly once.
      if (_isInvalidGuestSessionError(e) && request.guestSessionToken != null) {
        final freshToken = await GuestSessionManager.instance.refreshSession();
        final retryRequest = request.copyWith(guestSessionToken: freshToken);

        return await _submitOnce(retryRequest);
      }

      rethrow;
    }
  }

  bool _isInvalidGuestSessionError(ApiException e) {
    return e.statusCode == 422 &&
        e.errors != null &&
        e.errors!.containsKey('guest_session_token');
  }

  Future<AssessmentResponse> _submitOnce(
    StressAssessmentRequest request,
  ) async {
    try {

      final bool isLoggedIn =
      await SessionManager.instance.hasToken();

      final String endpoint = isLoggedIn
          ? '/client/assessment'
          : '/guest/assessment';

      final response = await _dio.post(
        endpoint,
        data: request.toJson(),
      );

      return AssessmentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<AssessmentDashboardResponse> getDashboard({DateTime? date}) async {
    try {
      final response = await _dio.get(
        '/client/assessment/dashboard',
        queryParameters: date != null
            ? {'date': DateFormat('yyyy-MM-dd').format(date)}
            : null,
      );

      return AssessmentDashboardResponse.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AssessmentHistoryResponse> getHistory(int days) async {
    try {
      final response = await _dio.get(
        '/client/assessment/history',
        queryParameters: {'days': days},
      );

      return AssessmentHistoryResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<InstrumentTrendResponse> getInstrumentTrend(int days) async {
    try {
      final response = await _dio.get(
        '/client/assessment/instrument-trend',
        queryParameters: {'days': days},
      );

      return InstrumentTrendResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.response == null) {
      return ApiException(message: 'Unable to connect to server.');
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
