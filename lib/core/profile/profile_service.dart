import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../models/api_response.dart';
import '../../models/profile_model.dart';
import '../../models/profile_request.dart';
import '../../models/specialist_profile_model.dart';
import '../../models/specialist_profile_request.dart';

class ProfileService {
  final Dio _dio = ApiClient().dio;

  //---------------------------------------------------
  // Complete Profile
  //---------------------------------------------------

  Future<ApiResponse> completeProfile(
      CompleteProfileRequest request,
      ) async {
    try {
      final response = await _dio.post(
        "/client/profile/complete",
        data: request.toJson(),
      );

      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProfileModel> loadProfile() async {
    try {
      final response = await _dio.get(
        "/client/profile/show",
      );

      return ProfileModel.fromJson(response.data);
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







  Future<ApiResponse> completeSpecialistProfile(
      CompleteSpecialistProfileRequest request,
      ) async {
    try {
      final formData = await request.toFormData();

      final response = await _dio.post(
        "/specialist/profile/complete",
        data: formData,
      );

      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<SpecialistProfileModel> loadSpecialistProfile() async {
    try {
      final response = await _dio.get(
        "/specialist/profile",
      );

      return SpecialistProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}