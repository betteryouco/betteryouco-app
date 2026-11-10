import 'package:flutter/cupertino.dart';

import '../auth/guest_session_manager.dart';
import '../network/api_exception.dart';
import 'guest_service.dart';
import 'guest_state.dart';

class GuestController extends ChangeNotifier {
  final GuestService _guestService = GuestService();

  GuestState _state = const GuestState();

  GuestState get state => _state;

  void _setState(GuestState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> continueAsGuest() async {
    _setState(
      _state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    try {
      await GuestSessionManager.instance.initialize();

      _setState(
        _state.copyWith(
          isLoading: false,
          isSuccess: true,
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.message,
        ),
      );

      return false;
    } catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );

      return false;
    }
  }
}