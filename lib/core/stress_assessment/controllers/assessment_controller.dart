import 'package:flutter/material.dart';

import '../../../models/stress_assessment_request.dart';
import '../../network/api_exception.dart';
import '../services/assessment_service.dart';
import '../state/assessment_state.dart';

class AssessmentController extends ChangeNotifier {
  final AssessmentService _service;

  AssessmentController(this._service);

  AssessmentState _state = AssessmentState.initial();

  AssessmentState get state => _state;

  void _setState(AssessmentState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> submitAssessment(
      StressAssessmentRequest request,
      ) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        isSuccess: false,
        errorMessage: null,
        validationErrors: null,
      ),
    );

    try {
      final response =
      await _service.submitAssessment(request);

      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: true,
          response: response,
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.message,
          sessionExpired: e.statusCode == 401,
          validationErrors: e.errors,
        ),
      );

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage:
          'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }

  Future<void> loadDashboard({DateTime? date}) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    try {
      final dashboard =
      await _service.getDashboard(date: date);

      _setState(
        _state.copyWith(
          isLoading: false,
          dashboard: dashboard,
        ),
      );
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }


  Future<void> loadHistory(int days) async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    try {
      final history = await _service.getHistory(days);

      _setState(
        _state.copyWith(
          isLoading: false,
          history: history,
        ),
      );
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> loadInstrumentTrend({int days = 90}) async {
    _setState(
      _state.copyWith(isLoadingTrend: true),
    );

    try {
      final trend = await _service.getInstrumentTrend(days);

      _setState(
        _state.copyWith(isLoadingTrend: false, instrumentTrend: trend),
      );
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoadingTrend: false,
          errorMessage: e.message,
          sessionExpired: e.statusCode == 401,
        ),
      );
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoadingTrend: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void reset() {
    _setState(
      AssessmentState.initial(),
    );
  }
}