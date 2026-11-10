import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/program_model.dart';

class ProgramService {
  final Dio _dio = ApiClient().dio;

  //---------------------------------------------------
  // My (assigned) Programs — programs are fixed/predefined and
  // admin-managed; a specialist only ever views what's assigned to them.
  //---------------------------------------------------

  Future<List<ProgramModel>> loadMyPrograms() async {
    try {
      final response = await _dio.get(
        "/specialist/programs/mine",
      );

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => ProgramModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Browse All Programs (client-facing)
  //---------------------------------------------------

  Future<List<ProgramModel>> loadAllPrograms() async {
    try {
      final response = await _dio.get(
        "/client/programs",
      );

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => ProgramModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Featured Programs (DASS-21 result screen paywall) — public, reachable
  // by guests before they have a session token.
  //---------------------------------------------------

  Future<List<ProgramModel>> loadFeaturedPrograms() async {
    try {
      final response = await _dio.get(
        "/guest/programs/featured",
      );

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => ProgramModel.fromJson(e)).toList();
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
