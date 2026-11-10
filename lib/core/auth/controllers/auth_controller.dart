import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../services/auth_service.dart';
import '../session_manager.dart';
import '../state/auth_state.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;

  AuthController(this._authService);

  AuthState _state = AuthState.initial();

  AuthState get state => _state;

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    String? phone,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
      );

      _setState(_state.copyWith(isLoading: false, isSuccess: true));

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      final result = await _authService.verifyOtp(email: email, otp: otp);

      final message = result['message'].toString();
      final token = result['data']['token']?.toString();

      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: true,
          token: token,
          errorMessage: message,
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  /// Sends a fresh signup verification code. On success the server's message
  /// is left in `errorMessage` (same convention as [forgotPassword]).
  Future<bool> resendOtp({required String email}) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      final result = await _authService.resendOtp(email: email);

      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: true,
          errorMessage: result['message'].toString(),
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required String role,
  }) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      final result = await _authService.login(
        email: email,
        password: password,
        role: role,
      );

      final token = result['data']?['token']?.toString();
      final user = result['data']?['user'];

      if (token == null || user == null) {
        _setState(
          _state.copyWith(
            isLoading: false,
            errorMessage: 'Unexpected response from server. Please try again.',
          ),
        );
        return false;
      }

      await SessionManager.instance.saveSession(
        token: token,
        user: user,
      );

      _setState(
        _state.copyWith(isLoading: false, isSuccess: true, token: token),
      );

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      // Guard against any non-ApiException error (an unexpected response
      // shape from the API, a secure-storage platform exception, etc.)
      // leaving isLoading stuck forever and the login screen spinning
      // indefinitely — matches the same fix already applied to
      // validateSession() below.
      _setState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      final result = await _authService.forgotPassword(email: email);

      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: true,
          errorMessage: result['message'].toString(),
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  Future<bool> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      await _authService.verifyResetOtp(email: email, otp: otp);

      _setState(_state.copyWith(isLoading: false, isSuccess: true));

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      await _authService.resetPassword(
        email: email,
        otp: otp,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      _setState(_state.copyWith(isLoading: false, isSuccess: true));

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  void clearError() {
    _setState(_state.copyWith(errorMessage: null, validationErrors: null));
  }

  String? getFieldError(String field) {
    final errors = _state.validationErrors;

    if (errors == null) {
      return null;
    }

    if (!errors.containsKey(field)) {
      return null;
    }

    final fieldErrors = errors[field];

    if (fieldErrors is List && fieldErrors.isNotEmpty) {
      return fieldErrors.first.toString();
    }

    return null;
  }

  Future<bool> validateSession() async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
        isSuccess: false,
      ),
    );

    try {
      await _authService.validateToken();

      _setState(_state.copyWith(isLoading: false, isSuccess: true));

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      // Guard against any non-ApiException error (e.g. a raw platform
      // exception from secure storage) leaving isLoading stuck forever
      // and the splash screen's loading overlay frozen indefinitely.
      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );

      return false;
    }
  }

  Future<bool> logout() async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
        isSuccess: false,
      ),
    );

    try {
      await _authService.logout();
      await SessionManager.instance.logout();

      _setState(_state.copyWith(isLoading: false, isSuccess: true));

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(isLoading: false, isSuccess: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      final request = await _authService.signInWithGoogle();

      if (request == null) {
        _setState(
          _state.copyWith(
            isLoading: false,
            errorMessage: null,
            validationErrors: null,
          ),
        );
        return false;
      }

      final response = await _authService.socialLogin(request);

      await SessionManager.instance.saveSession(
        token: response['data']['token'],
        user: response['data']['user'],
      );

      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: true,
          token: response['data']['token'].toString(),
        ),
      );
      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );

      return false;
    }
  }

  /*Future<bool> loginWithFacebook() async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      final request = await _authService.signInWithFacebook();

      if (request == null) {
        _setState(
          _state.copyWith(
            isLoading: false,
            errorMessage: null,
            validationErrors: null,
          ),
        );
        return false;
      }

      final response = await _authService.socialLogin(request);
      await SessionManager.instance.saveSession(
        token: response['data']['token'],
        user: response['data']['user'],
      );

      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: true,
          token: response['data']['token'].toString(),
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          validationErrors: e.errors,
        ),
      );

      return false;
    }
  }*/
}
