import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import 'specialist_dashboard_service.dart';
import 'specialist_dashboard_state.dart';

class SpecialistDashboardController extends ChangeNotifier {
  final SpecialistDashboardService _service;

  SpecialistDashboardController(this._service);

  SpecialistDashboardState _state = SpecialistDashboardState.initial();

  SpecialistDashboardState get state => _state;

  void _setState(SpecialistDashboardState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadDashboard() async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final dashboard = await _service.loadDashboard();

      _setState(_state.copyWith(isLoading: false, dashboard: dashboard));
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
