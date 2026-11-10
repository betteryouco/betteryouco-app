import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import 'conversation_service.dart';
import 'conversation_state.dart';

class ConversationController extends ChangeNotifier {
  final ConversationService _service;

  ConversationController(this._service);

  ConversationState _state = ConversationState.initial();

  ConversationState get state => _state;

  void _setState(ConversationState state) {
    _state = state;
    notifyListeners();
  }

  //---------------------------------------------------
  // Conversations List
  //---------------------------------------------------

  Future<void> loadClientConversations() async {
    _setState(_state.copyWith(isLoadingList: true, errorMessage: null));

    try {
      final conversations = await _service.loadClientConversations();

      _setState(
        _state.copyWith(isLoadingList: false, clientConversations: conversations),
      );
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoadingList: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoadingList: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> loadSpecialistConversations() async {
    _setState(_state.copyWith(isLoadingList: true, errorMessage: null));

    try {
      final conversations = await _service.loadSpecialistConversations();

      _setState(
        _state.copyWith(
          isLoadingList: false,
          specialistConversations: conversations,
        ),
      );
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoadingList: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoadingList: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  //---------------------------------------------------
  // Start / Resume Conversation
  //---------------------------------------------------

  Future<int?> startClientConversation(int specialistId) async {
    try {
      return await _service.startClientConversation(specialistId);
    } on ApiException catch (e) {
      _setState(_state.copyWith(errorMessage: e.message));

      return null;
    } catch (_) {
      _setState(
        _state.copyWith(
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return null;
    }
  }

  Future<int?> startSpecialistConversation(int enrollmentId) async {
    try {
      return await _service.startSpecialistConversation(enrollmentId);
    } on ApiException catch (e) {
      _setState(_state.copyWith(errorMessage: e.message));

      return null;
    } catch (_) {
      _setState(
        _state.copyWith(
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return null;
    }
  }

  //---------------------------------------------------
  // Thread
  //---------------------------------------------------

  Future<void> loadThread(int conversationId, {required bool isSpecialist}) async {
    _setState(_state.copyWith(isLoadingThread: true, errorMessage: null));

    try {
      final messages = isSpecialist
          ? await _service.loadSpecialistMessages(conversationId)
          : await _service.loadClientMessages(conversationId);

      final booking = isSpecialist
          ? await _service.getSpecialistBooking(conversationId)
          : await _service.getClientBooking(conversationId);

      _setState(
        _state.copyWith(
          isLoadingThread: false,
          messages: messages,
          booking: booking,
          clearBooking: booking == null,
        ),
      );
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoadingThread: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoadingThread: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<bool> sendMessage(
    int conversationId,
    String body, {
    required bool isSpecialist,
  }) async {
    _setState(_state.copyWith(isSending: true, errorMessage: null));

    try {
      final message = isSpecialist
          ? await _service.sendSpecialistMessage(conversationId, body)
          : await _service.sendClientMessage(conversationId, body);

      _setState(
        _state.copyWith(
          isSending: false,
          messages: [..._state.messages, message],
        ),
      );

      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isSending: false, errorMessage: e.message));

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isSending: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }

  //---------------------------------------------------
  // Booking
  //---------------------------------------------------

  Future<bool> requestSession(int conversationId) async {
    _setState(_state.copyWith(isBookingBusy: true, errorMessage: null));

    try {
      final booking = await _service.requestSession(conversationId);

      _setState(_state.copyWith(isBookingBusy: false, booking: booking));

      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isBookingBusy: false, errorMessage: e.message));

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isBookingBusy: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }

  Future<bool> scheduleSession({
    required int bookingId,
    required DateTime scheduledAt,
    int? durationMin,
    required String videoRoomId,
  }) async {
    _setState(_state.copyWith(isBookingBusy: true, errorMessage: null));

    try {
      final booking = await _service.scheduleSession(
        bookingId: bookingId,
        scheduledAt: scheduledAt,
        durationMin: durationMin,
        videoRoomId: videoRoomId,
      );

      _setState(_state.copyWith(isBookingBusy: false, booking: booking));

      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isBookingBusy: false, errorMessage: e.message));

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isBookingBusy: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }
}
