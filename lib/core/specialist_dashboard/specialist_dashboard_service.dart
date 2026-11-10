import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/specialist_dashboard_model.dart';

class SpecialistDashboardService {
  final Dio _dio = ApiClient().dio;

  Future<SpecialistDashboardModel> loadDashboard() async {
    try {
      final response = await _dio.get("/specialist/dashboard");

      return SpecialistDashboardModel.fromJson(response.data["data"]);
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

    return ApiException(
      message: data["message"] ?? "Something went wrong.",
      statusCode: e.response?.statusCode,
    );
  }
}
