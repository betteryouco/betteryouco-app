import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import 'program_service.dart';
import 'program_state.dart';

class ProgramController extends ChangeNotifier {
  final ProgramService _service;

  ProgramController(this._service);

  ProgramState _state = ProgramState.initial();

  ProgramState get state => _state;

  void _setState(ProgramState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadMyPrograms() async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final programs = await _service.loadMyPrograms();

      _setState(_state.copyWith(isLoading: false, programs: programs));
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

  Future<void> loadAllPrograms() async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final programs = await _service.loadAllPrograms();

      _setState(_state.copyWith(isLoading: false, browsePrograms: programs));
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
