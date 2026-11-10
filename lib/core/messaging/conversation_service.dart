import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/booking_model.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';

class ConversationService {
  final Dio _dio = ApiClient().dio;

  //---------------------------------------------------
  // Conversations List
  //---------------------------------------------------

  Future<List<ConversationSummary>> loadClientConversations() async {
    return _loadConversations("/client/conversations");
  }

  Future<List<ConversationSummary>> loadSpecialistConversations() async {
    return _loadConversations("/specialist/conversations");
  }

  Future<List<ConversationSummary>> _loadConversations(String path) async {
    try {
      final response = await _dio.get(path);

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => ConversationSummary.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Start / Resume Conversation
  //---------------------------------------------------

  Future<int> startClientConversation(int specialistId) async {
    try {
      final response = await _dio.post(
        "/client/conversations",
        data: {"specialist_id": specialistId},
      );

      return response.data["data"]["conversation_id"];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<int> startSpecialistConversation(int enrollmentId) async {
    try {
      final response = await _dio.post(
        "/specialist/conversations",
        data: {"enrollment_id": enrollmentId},
      );

      return response.data["data"]["conversation_id"];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Message Thread
  //---------------------------------------------------

  Future<List<MessageModel>> loadClientMessages(int conversationId) async {
    return _loadMessages("/client/conversations/$conversationId/messages");
  }

  Future<List<MessageModel>> loadSpecialistMessages(int conversationId) async {
    return _loadMessages("/specialist/conversations/$conversationId/messages");
  }

  Future<List<MessageModel>> _loadMessages(String path) async {
    try {
      final response = await _dio.get(path);

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => MessageModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MessageModel> sendClientMessage(int conversationId, String body) async {
    return _sendMessage("/client/conversations/$conversationId/messages", body);
  }

  Future<MessageModel> sendSpecialistMessage(int conversationId, String body) async {
    return _sendMessage(
      "/specialist/conversations/$conversationId/messages",
      body,
    );
  }

  Future<MessageModel> _sendMessage(String path, String body) async {
    try {
      final response = await _dio.post(path, data: {"body": body});

      return MessageModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Booking
  //---------------------------------------------------

  Future<BookingModel?> getClientBooking(int conversationId) async {
    return _getBooking("/client/conversations/$conversationId/booking");
  }

  Future<BookingModel?> getSpecialistBooking(int conversationId) async {
    return _getBooking("/specialist/conversations/$conversationId/booking");
  }

  Future<BookingModel?> _getBooking(String path) async {
    try {
      final response = await _dio.get(path);

      final data = response.data["data"];

      return data != null ? BookingModel.fromJson(data) : null;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> requestSession(int conversationId) async {
    try {
      final response = await _dio.post(
        "/client/conversations/$conversationId/booking",
      );

      return BookingModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> scheduleSession({
    required int bookingId,
    required DateTime scheduledAt,
    int? durationMin,
    required String videoRoomId,
  }) async {
    try {
      final response = await _dio.post(
        "/specialist/bookings/$bookingId/schedule",
        data: {
          "scheduled_at": scheduledAt.toIso8601String(),
          if (durationMin != null) "duration_min": durationMin,
          "video_room_id": videoRoomId,
        },
      );

      return BookingModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<BookingModel>> loadPendingBookings() async {
    try {
      final response = await _dio.get("/specialist/bookings/pending");

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => BookingModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //---------------------------------------------------
  // Error Handler
  //---------------------------------------------------

  ApiException _handleError(DioException e) {
    if (e.response == null) {
      return ApiException(
        message: "Unable to connect to server.",
      );
    }

    final data = e.response?.data;

    if (e.response?.statusCode == 422) {
      return ApiException(
        message: data["message"] ?? "Validation failed.",
        statusCode: 422,
        errors: data["errors"],
      );
    }

    return ApiException(
      message: data["message"] ?? "Something went wrong.",
      statusCode: e.response?.statusCode,
    );
  }
}
