import '../../models/booking_model.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';

class ConversationState {
  final bool isLoadingList;
  final bool isLoadingThread;
  final bool isSending;
  final bool isBookingBusy;
  final String? errorMessage;

  final List<ConversationSummary> clientConversations;
  final List<ConversationSummary> specialistConversations;

  final List<MessageModel> messages;
  final BookingModel? booking;

  const ConversationState({
    this.isLoadingList = false,
    this.isLoadingThread = false,
    this.isSending = false,
    this.isBookingBusy = false,
    this.errorMessage,
    this.clientConversations = const [],
    this.specialistConversations = const [],
    this.messages = const [],
    this.booking,
  });

  factory ConversationState.initial() {
    return const ConversationState();
  }

  ConversationState copyWith({
    bool? isLoadingList,
    bool? isLoadingThread,
    bool? isSending,
    bool? isBookingBusy,
    String? errorMessage,
    List<ConversationSummary>? clientConversations,
    List<ConversationSummary>? specialistConversations,
    List<MessageModel>? messages,
    BookingModel? booking,
    bool clearBooking = false,
  }) {
    return ConversationState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingThread: isLoadingThread ?? this.isLoadingThread,
      isSending: isSending ?? this.isSending,
      isBookingBusy: isBookingBusy ?? this.isBookingBusy,
      errorMessage: errorMessage,
      clientConversations: clientConversations ?? this.clientConversations,
      specialistConversations:
          specialistConversations ?? this.specialistConversations,
      messages: messages ?? this.messages,
      booking: clearBooking ? null : (booking ?? this.booking),
    );
  }
}
