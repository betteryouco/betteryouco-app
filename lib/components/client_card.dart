import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/client_model.dart';
import '../theme/app_colors.dart';
import 'text_2.dart';
import 'text_4.dart';

class ClientCard extends StatelessWidget {
  final ClientListItem client;
  final VoidCallback? onTap;

  const ClientCard({super.key, required this.client, this.onTap});

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
              backgroundColor: AppColors.blobs1,
              child: Text(
                client.clientName.isNotEmpty
                    ? client.clientName[0].toUpperCase()
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
                  Text4(client.clientName),
                  const SizedBox(height: 2),
                  Text2(client.programName),
                ],
              ),
            ),
            if (client.currentWeek != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text2("Week ${client.currentWeek}"),
                  if (client.durationWeeks != null)
                    Text2("of ${client.durationWeeks}"),
                ],
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.bodyText),
          ],
        ),
      ),
    );
  }
}
