import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/app_background.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../components/text_4.dart';
import '../../core/note/note_controller.dart';
import '../../core/stress_assessment/controllers/assessment_controller.dart';
import '../../models/assessment_history_model.dart';
import '../../models/note_model.dart';
import '../../theme/app_colors.dart';

class AssessmentHistoryScreen extends StatefulWidget {
  const AssessmentHistoryScreen({super.key});

  @override
  State<AssessmentHistoryScreen> createState() =>
      _AssessmentHistoryScreenState();
}

class _AssessmentHistoryScreenState extends State<AssessmentHistoryScreen> {
  int _days = 30;

  void _selectDays(int days) {
    if (_days == days) return;

    setState(() => _days = days);

    context.read<AssessmentController>().loadHistory(days);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Consumer2<AssessmentController, NoteController>(
            builder: (context, assessmentController, noteController, child) {
              final state = assessmentController.state;
              final history = state.history;

              return BlurryModalProgressHUD(
                inAsyncCall: state.isLoading,
                blurEffectIntensity: 7,
                progressIndicator: SpinKitFadingCircle(
                  color: AppColors.primaryBtn,
                  size: 90.0.w,
                ),
                dismissible: false,
                opacity: 0.2,
                color: AppColors.blobs1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          Expanded(child: Text1("Assessment History")),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDayRangeToggle(),
                      const SizedBox(height: 16),
                      if (history != null) _buildBaselineCard(history),
                      const SizedBox(height: 24),
                      Text4("Score Log"),
                      const SizedBox(height: 12),
                      _buildScoreLog(history),
                      const SizedBox(height: 24),
                      Text4("Specialist Notes"),
                      const SizedBox(height: 12),
                      _buildNotesList(noteController.state.notes),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDayRangeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Expanded(child: _rangeSegment("30 Days", 30)),
          Expanded(child: _rangeSegment("90 Days", 90)),
          Expanded(child: _rangeSegment("1 Year", 365)),
        ],
      ),
    );
  }

  Widget _rangeSegment(String label, int days) {
    final selected = _days == days;

    return GestureDetector(
      onTap: () => _selectDays(days),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBtn : Colors.transparent,
          borderRadius: BorderRadius.circular(26.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.bodyText,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildBaselineCard(AssessmentHistoryResponse history) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _statColumn(
              "Baseline",
              history.baseline?.score.toString() ?? "--",
            ),
          ),
          Expanded(
            child: _statColumn(
              "Current",
              history.current?.score.toString() ?? "--",
            ),
          ),
          Expanded(
            child: _statColumn(
              "% Change",
              history.percentChange != null
                  ? "${history.percentChange!.toStringAsFixed(0)}%"
                  : "--",
            ),
          ),
        ],
      ),
    );
  }

  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBtn,
          ),
        ),
        const SizedBox(height: 4),
        Text2(label),
      ],
    );
  }

  Widget _buildScoreLog(AssessmentHistoryResponse? history) {
    final entries = history?.history.reversed.toList() ?? [];

    if (entries.isEmpty) {
      return Text2("No assessments in this range.");
    }

    return Column(
      children: entries.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text2(DateFormat('MMM d, y').format(item.submittedAt)),
                    const SizedBox(height: 2),
                    Text4(item.interpretation),
                  ],
                ),
              ),
              Text4(item.score.toString()),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotesList(List<NoteModel> notes) {
    if (notes.isEmpty) {
      return Text2("No notes from your specialist yet.");
    }

    return Column(
      children: notes.map((note) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text4(note.specialistName),
                  if (note.createdAt != null)
                    Text(
                      DateFormat('MMM d, y').format(note.createdAt!),
                      style: TextStyle(fontSize: 11.sp, color: AppColors.bodyText),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text2(note.body),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssessmentController>().loadHistory(_days);
      context.read<NoteController>().loadMyNotes();
    });
  }
}
