import 'package:flutter/material.dart';

import '../network/api_exception.dart';
import 'assignment_service.dart';
import 'assignment_state.dart';

class AssignmentController extends ChangeNotifier {
  final AssignmentService _service;

  AssignmentController(this._service);

  AssignmentState _state = AssignmentState.initial();

  AssignmentState get state => _state;

  void _setState(AssignmentState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadPending() async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final requests = await _service.pending();

      _setState(_state.copyWith(isLoading: false, pendingRequests: requests));
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<bool> accept(int enrollmentId) async {
    try {
      await _service.accept(enrollmentId);

      _setState(
        _state.copyWith(
          pendingRequests: _state.pendingRequests
              .where((r) => r.enrollmentId != enrollmentId)
              .toList(),
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(errorMessage: e.message));
      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
      return false;
    }
  }

  Future<bool> decline(int enrollmentId) async {
    try {
      await _service.decline(enrollmentId);

      _setState(
        _state.copyWith(
          pendingRequests: _state.pendingRequests
              .where((r) => r.enrollmentId != enrollmentId)
              .toList(),
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(errorMessage: e.message));
      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
      return false;
    }
  }
}
