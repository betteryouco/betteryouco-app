import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../models/conversation_model.dart';
import '../theme/app_colors.dart';
import 'text_2.dart';
import 'text_4.dart';

class ConversationCard extends StatelessWidget {
  final ConversationSummary conversation;
  final VoidCallback? onTap;

  const ConversationCard({super.key, required this.conversation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.blobs2,
              child: Text(
                conversation.name.isNotEmpty
                    ? conversation.name[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  color: AppColors.primaryBtn,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text4(conversation.name),
                  const SizedBox(height: 2),
                  Text2(
                    conversation.lastMessage ?? "No messages yet",
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (conversation.lastMessageAt != null)
                  Text(
                    DateFormat('MMM d').format(conversation.lastMessageAt!),
                    style: TextStyle(fontSize: 11.sp, color: AppColors.bodyText),
                  ),
                if (conversation.unread) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBtn,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
