import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

import '../../../models/social_login_request.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    String? phone,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role': role,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/verify-otp',
        data: {'email': email, 'otp': otp},
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    try {
      final response = await _dio.post(
        '/auth/resend-otp',
        data: {'email': email},
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password, 'role': role},
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password/verify-otp',
        data: {'email': email, 'otp': otp},
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password/reset',
        data: {
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return response.data;
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

  Future<bool> validateToken() async {
    try {
      final response = await _dio.get('/client/validate-token');

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return false;
      }

      throw _handleError(e);
    } catch (e) {
      throw ApiException(message: 'Unable to validate session: $e');
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _dio.post('/client/logout');

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<SocialLoginRequest?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account == null) {
      return null;
    }

    final GoogleSignInAuthentication auth = await account.authentication;

    if (auth.idToken == null) {
      return null;
    }

    return SocialLoginRequest(provider: "google", token: auth.idToken!);
  }

 /* Future<SocialLoginRequest?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status != LoginStatus.success) {
      return null;
    }

    final token = result.accessToken?.token;

    if (token == null) {
      return null;
    }

    return SocialLoginRequest(provider: "facebook", token: token);
  } */

  Future<Map<String, dynamic>> socialLogin(SocialLoginRequest request) async {
    try {
      final response = await _dio.post(
        "/auth/social-login",
        data: request.toJson(),
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}
