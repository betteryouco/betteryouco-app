import 'package:flutter/material.dart';

import '../network/api_exception.dart';
import 'purchase_service.dart';
import 'purchase_state.dart';

class PurchaseController extends ChangeNotifier {
  final PurchaseService _service;

  PurchaseController(this._service);

  PurchaseState _state = PurchaseState.initial();

  PurchaseState get state => _state;

  void _setState(PurchaseState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> purchase(int programId) async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final payment = await _service.purchase(programId);

      _setState(_state.copyWith(isLoading: false, currentPayment: payment));
      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.message));
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

  Future<bool> confirmMockPayment(int paymentId) async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final payment = await _service.confirmMockPayment(paymentId);

      _setState(_state.copyWith(isLoading: false, currentPayment: payment));
      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.message));
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

  Future<bool> renew(int enrollmentId) async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final payment = await _service.renew(enrollmentId);

      _setState(_state.copyWith(isLoading: false, currentPayment: payment));
      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.message));
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

  Future<void> loadMyEnrollments() async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final enrollments = await _service.myEnrollments();

      _setState(_state.copyWith(isLoading: false, enrollments: enrollments));
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
}
