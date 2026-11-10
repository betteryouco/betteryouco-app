import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/conversation_card.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../core/messaging/conversation_controller.dart';
import '../../theme/app_colors.dart';
import '../shared/message_thread_screen.dart';

class ExpertMessagesScreen extends StatefulWidget {
  const ExpertMessagesScreen({super.key});

  @override
  State<ExpertMessagesScreen> createState() => ExpertMessagesScreenState();
}

class ExpertMessagesScreenState extends State<ExpertMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationController>(
      builder: (context, controller, child) {
        final state = controller.state;
        final conversations = state.specialistConversations;

        return BlurryModalProgressHUD(
          inAsyncCall: state.isLoadingList,
          blurEffectIntensity: 7,
          progressIndicator: SpinKitFadingCircle(
            color: AppColors.primaryBtn,
            size: 90.0.w,
          ),
          dismissible: false,
          opacity: 0.2,
          color: AppColors.blobs1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text1("Messages"),
              const SizedBox(height: 4),
              Text2("Conversations with your clients."),
              const SizedBox(height: 20),
              Expanded(
                child: conversations.isEmpty && !state.isLoadingList
                    ? Center(child: Text2("No conversations yet."))
                    : RefreshIndicator(
                        onRefresh: () => controller.loadSpecialistConversations(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: conversations.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final conversation = conversations[index];

                            return ConversationCard(
                              conversation: conversation,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MessageThreadScreen(
                                      conversationId: conversation.conversationId,
                                      isSpecialist: true,
                                      otherPartyName: conversation.name,
                                    ),
                                  ),
                                );

                                if (context.mounted) {
                                  context.read<ConversationController>().loadSpecialistConversations();
                                }
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
