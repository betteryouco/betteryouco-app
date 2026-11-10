import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/program_model.dart';
import '../theme/app_colors.dart';
import 'text_2.dart';
import 'text_4.dart';

class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback? onTap;

  const ProgramCard({super.key, required this.program, this.onTap});

  String get _durationLabel {
    final min = program.durationWeeks;
    final max = program.durationWeeksMax;

    if (min == null) return "Duration not set";
    if (max == null || max == min) return "$min weeks";
    return "$min–$max weeks";
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text4(program.title.isEmpty ? "Untitled Program" : program.title),
                ),
                if (program.price != null)
                  Text4(
                    "${program.currency ?? ''} ${program.price!.toStringAsFixed(0)}",
                  ),
              ],
            ),
            if (program.description != null && program.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text2(program.description!),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.bodyText),
                const SizedBox(width: 4),
                Text2(_durationLabel),
                const SizedBox(width: 16),
                Icon(Icons.view_module_outlined, size: 14, color: AppColors.bodyText),
                const SizedBox(width: 4),
                Text2("${program.contentModules.length} modules"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
