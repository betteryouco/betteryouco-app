import 'package:betteryou_co/core/profile/profile_service.dart';
import 'package:betteryou_co/core/profile/profile_state.dart';
import 'package:betteryou_co/core/profile/profile_state.dart';
import 'package:betteryou_co/core/profile/profile_state.dart';
import 'package:betteryou_co/core/profile/profile_state.dart';
import 'package:betteryou_co/models/specialist_profile_request.dart';
import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';

import '../../../models/blood_pressure_request.dart';
import '../../../models/bmi_request.dart';
import '../../../models/heart_rate_request.dart';
import '../../models/profile_request.dart';

class ProfileeController extends ChangeNotifier {
  final ProfileService _service;

  ProfileeController(this._service);

  ProfileState _state = ProfileState.initial();

  ProfileState get state => _state;

  bool get isLoading => _state.isLoading;

  bool get isSuccess => _state.isSuccess;

  String? get errorMessage => _state.errorMessage;

  String? get successMessage => _state.successMessage;

  void _setState(ProfileState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> completeProfile(CompleteProfileRequest request) async {
    _startLoading();

    try {
      final response = await _service.completeProfile(request);

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

  Future<void> loadSummary() async {
    _startLoading();

    try {
      final summary = await _service.loadProfile();

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



  Future<bool> completeSpecialistProfile(CompleteSpecialistProfileRequest request) async {
    _startLoading();

    try {
      final response = await _service.completeSpecialistProfile(request);

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

  Future<void> loadSpecialistProfile() async {
    _startLoading();

    try {

      final profile =
      await _service.loadSpecialistProfile();

      _setState(
        _state.copyWith(
          isLoading: false,
          specialistProfile: profile,
        ),
      );

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
