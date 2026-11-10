import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import 'note_service.dart';
import 'note_state.dart';

class NoteController extends ChangeNotifier {
  final NoteService _service;

  NoteController(this._service);

  NoteState _state = NoteState.initial();

  NoteState get state => _state;

  void _setState(NoteState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadMyNotes() async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final notes = await _service.loadMyNotes();

      _setState(_state.copyWith(isLoading: false, notes: notes));
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

  Future<void> loadClientNotes(int enrollmentId) async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final notes = await _service.loadClientNotes(enrollmentId);

      _setState(_state.copyWith(isLoading: false, notes: notes));
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

  Future<bool> addNote(int enrollmentId, String body) async {
    _setState(_state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final note = await _service.addNote(enrollmentId, body);

      _setState(
        _state.copyWith(isSubmitting: false, notes: [note, ..._state.notes]),
      );

      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isSubmitting: false, errorMessage: e.message));

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isSubmitting: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }
}
