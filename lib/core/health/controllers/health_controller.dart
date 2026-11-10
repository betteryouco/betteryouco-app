import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';

import '../../../models/blood_pressure_request.dart';
import '../../../models/bmi_request.dart';
import '../../../models/heart_rate_request.dart';
import '../../../models/sleep_request.dart';
import '../services/health_service.dart';
import '../state/health_state.dart';

class HealthController extends ChangeNotifier {
  final HealthService _service;

  HealthController(this._service);

  HealthState _state = HealthState.initial();

  HealthState get state => _state;

  bool get isLoading => _state.isLoading;

  bool get isSuccess => _state.isSuccess;

  String? get errorMessage => _state.errorMessage;

  String? get successMessage => _state.successMessage;

  void _setState(HealthState state) {
    _state = state;
    notifyListeners();
  }

  //---------------------------------------------------
  // Blood Pressure
  //---------------------------------------------------

  Future<bool> saveBloodPressure(BloodPressureRequest request) async {
    _startLoading();

    try {
      final response = await _service.saveBloodPressure(request);

      _success(response.message);

      return true;
    } on ApiException catch (e) {
      _error(e);

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }

  //---------------------------------------------------
  // Heart Rate
  //---------------------------------------------------

  Future<bool> saveHeartRate(HeartRateRequest request) async {
    _startLoading();

    try {
      final response = await _service.saveHeartRate(request);

      _success(response.message);

      return true;
    } on ApiException catch (e) {
      _error(e);

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }

  //---------------------------------------------------
  // BMI
  //---------------------------------------------------

  Future<bool> saveBMI(BMIRequest request) async {
    _startLoading();

    try {
      final response = await _service.saveBMI(request);

      _success(response.message);

      return true;
    } on ApiException catch (e) {
      _error(e);

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }

  //---------------------------------------------------
  // Sleep
  //---------------------------------------------------

  Future<bool> saveSleep(SleepRequest request) async {
    _startLoading();

    try {
      final response = await _service.saveSleep(request);

      _success(response.message);

      return true;
    } on ApiException catch (e) {
      _error(e);

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }

  //---------------------------------------------------
  // Helpers
  //---------------------------------------------------

  void _startLoading() {
    _setState(
      _state.copyWith(
        isLoading: true,
        isSuccess: false,
        errorMessage: null,
        successMessage: null,
        validationErrors: null,
      ),
    );
  }

  void _success(String message) {
    _setState(
      _state.copyWith(
        isLoading: false,
        isSuccess: true,
        successMessage: message,
      ),
    );
  }

  void _error(ApiException e) {
    _setState(
      _state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.message,
        validationErrors: e.errors,
      ),
    );
  }

  //---------------------------------------------------
  // Validation
  //---------------------------------------------------

  String? getFieldError(String field) {
    final errors = _state.validationErrors;

    if (errors == null) {
      return null;
    }

    if (!errors.containsKey(field)) {
      return null;
    }

    final value = errors[field];

    if (value is List && value.isNotEmpty) {
      return value.first.toString();
    }

    return null;
  }

  //---------------------------------------------------
  // Clear
  //---------------------------------------------------

  void clearState() {
    _setState(HealthState.initial());
  }

  Future<void> loadSummary(DateTime date) async {
    _startLoading();

    try {
      final summary = await _service.getSummary(date);

      _setState(_state.copyWith(isLoading: false, summary: summary));
    } on ApiException catch (e) {
      _error(e);
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
