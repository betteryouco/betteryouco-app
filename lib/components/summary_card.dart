import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/components/text_2.dart';
import 'package:betteryou_co/components/text_3.dart';
import 'package:betteryou_co/components/text_4.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  final String title;

  /// Large value
  final String value;

  /// Small suffix like /100
  final String? suffix;

  /// Subtitle
  final String subtitle;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xff263238);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 22, color: iconColor),

                const SizedBox(width: 6),

                Expanded(
                  child: Text2(title)
                ),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text1(value),

                if (suffix != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 4),
                    child: Text(
                      suffix!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            Text2(subtitle)
          ],
        ),
      ),
    );
  }
}
