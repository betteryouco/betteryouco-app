import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/app_background.dart';
import '../../components/form_field.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../core/auth/session_manager.dart';
import '../../core/messaging/conversation_controller.dart';
import '../../core/messaging/conversation_state.dart';
import '../../models/message_model.dart';
import '../../theme/app_colors.dart';

class MessageThreadScreen extends StatefulWidget {
  final int conversationId;
  final bool isSpecialist;
  final String otherPartyName;

  const MessageThreadScreen({
    super.key,
    required this.conversationId,
    required this.isSpecialist,
    required this.otherPartyName,
  });

  @override
  State<MessageThreadScreen> createState() => _MessageThreadScreenState();
}

class _MessageThreadScreenState extends State<MessageThreadScreen> {
  final _bodyController = TextEditingController();
  final _scrollController = ScrollController();

  int? _myUserId;

  Future<void> _loadUser() async {
    final user = await SessionManager.instance.getUser();

    if (!mounted) return;

    setState(() {
      _myUserId = user?['id'];
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _send() async {
    final text = _bodyController.text.trim();

    if (text.isEmpty) return;

    final controller = context.read<ConversationController>();

    final success = await controller.sendMessage(
          widget.conversationId,
          text,
          isSpecialist: widget.isSpecialist,
        );

    if (!mounted) return;

    if (success) {
      // Only clear the input once the message is actually confirmed sent —
      // clearing it eagerly meant a failed send silently lost what the
      // user typed, with no error shown.
      _bodyController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.state.errorMessage ?? "Message failed to send. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _requestSession() async {
    await context.read<ConversationController>().requestSession(
          widget.conversationId,
        );
  }

  Future<void> _openScheduleSheet(int bookingId) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    final durationController = TextEditingController(text: "30");
    final linkController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text1("Schedule Session"),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        selectedDate == null
                            ? "Choose date"
                            : DateFormat('MMM d, y').format(selectedDate!),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: sheetContext,
                          initialDate: DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );

                        if (picked != null) {
                          setSheetState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        selectedTime == null
                            ? "Choose time"
                            : selectedTime!.format(sheetContext),
                      ),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: sheetContext,
                          initialTime: TimeOfDay.now(),
                        );

                        if (picked != null) {
                          setSheetState(() => selectedTime = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      controller: durationController,
                      hintText: "Duration (minutes)",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      controller: linkController,
                      hintText: "Google Meet link or meeting ID",
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBtn,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () async {
                          if (selectedDate == null ||
                              selectedTime == null ||
                              linkController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(sheetContext).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill in date, time, and meeting link."),
                              ),
                            );
                            return;
                          }

                          final scheduledAt = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );

                          final success = await context
                              .read<ConversationController>()
                              .scheduleSession(
                                bookingId: bookingId,
                                scheduledAt: scheduledAt,
                                durationMin: int.tryParse(durationController.text.trim()),
                                videoRoomId: linkController.text.trim(),
                              );

                          if (sheetContext.mounted) Navigator.pop(sheetContext);

                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Session scheduled.")),
                            );
                          }
                        },
                        child: const Text(
                          "Confirm Schedule",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Consumer<ConversationController>(
            builder: (context, controller, child) {
              final state = controller.state;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Expanded(child: Text1(widget.otherPartyName)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildBookingCard(state),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: state.isLoadingThread
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.primaryBtn),
                          )
                        : state.messages.isEmpty
                            ? Center(
                                child: Text2("No messages yet — say hello."),
                              )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];

                              return _buildBubble(message, message.senderId == _myUserId);
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            controller: _bodyController,
                            hintText: "Type a message",
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: state.isSending ? null : _send,
                          icon: const Icon(Icons.send, color: AppColors.primaryBtn),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(MessageModel message, bool isMine) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primaryBtn : AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.body ?? '',
              style: TextStyle(color: isMine ? Colors.white : AppColors.headingText),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('h:mm a').format(message.sentAt),
              style: TextStyle(
                fontSize: 10,
                color: isMine ? Colors.white70 : AppColors.bodyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(ConversationState state) {
    final booking = state.booking;

    if (booking == null) {
      if (widget.isSpecialist) return const SizedBox.shrink();

      return _bookingCardShell(
        child: Row(
          children: [
            Expanded(child: Text2("Need a live session with your specialist?")),
            const SizedBox(width: 8),
            _smallButton(
              "Book Session",
              state.isBookingBusy ? null : _requestSession,
            ),
          ],
        ),
      );
    }

    if (booking.isPending) {
      return _bookingCardShell(
        child: Row(
          children: [
            Expanded(
              child: Text2(
                widget.isSpecialist
                    ? "Session requested — pick a date/time."
                    : "Session requested — waiting for your specialist.",
              ),
            ),
            if (widget.isSpecialist) ...[
              const SizedBox(width: 8),
              _smallButton(
                "Schedule",
                state.isBookingBusy ? null : () => _openScheduleSheet(booking.id),
              ),
            ],
          ],
        ),
      );
    }

    // Backend currently only ever produces 'pending'/'scheduled', but
    // don't silently render an unrecognized future status (cancelled,
    // completed, ...) as if it were still an active scheduled session.
    if (!booking.isScheduled) {
      return const SizedBox.shrink();
    }

    return _bookingCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text2(
            booking.scheduledAt != null
                ? "Scheduled for ${DateFormat('MMM d, y · h:mm a').format(booking.scheduledAt!)}"
                : "Scheduled",
          ),
          if (booking.videoRoomId != null && booking.videoRoomId!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.videoRoomId!,
                    style: const TextStyle(
                      color: AppColors.primaryBtn,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: booking.videoRoomId!));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Meeting link copied.")),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _bookingCardShell({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }

  Widget _smallButton(String label, VoidCallback? onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBtn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
    );
  }

  @override
  void initState() {
    super.initState();

    _loadUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ConversationController>()
          .loadThread(widget.conversationId, isSpecialist: widget.isSpecialist)
          .then((_) => _scrollToBottom());
    });
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
