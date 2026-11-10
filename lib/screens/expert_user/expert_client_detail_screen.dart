import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/app_background.dart';
import '../../components/button_1.dart';
import '../../components/button_2.dart';
import '../../components/chart_blood_pressure.dart';
import '../../components/chart_heart_rate.dart';
import '../../components/form_field.dart';
import '../../components/measurement_cards.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../components/text_4.dart';
import '../../core/client/client_controller.dart';
import '../../core/client/client_state.dart';
import '../../core/messaging/conversation_controller.dart';
import '../../core/note/note_controller.dart';
import '../../core/task/task_controller.dart';
import '../../models/client_task_model.dart';
import '../../models/note_model.dart';
import '../../models/stress_assessment_dashboard_response.dart';
import '../../models/task_request.dart';
import '../../theme/app_colors.dart';
import '../shared/message_thread_screen.dart';

class ExpertClientDetailScreen extends StatefulWidget {
  final int enrollmentId;

  const ExpertClientDetailScreen({super.key, required this.enrollmentId});

  @override
  State<ExpertClientDetailScreen> createState() =>
      _ExpertClientDetailScreenState();
}

class _ExpertClientDetailScreenState extends State<ExpertClientDetailScreen> {
  final _customTaskController = TextEditingController();
  final _noteController = TextEditingController();

  static const _presetTasks = [
    ("Complete the DASS-21 assessment", "assessment"),
    ("Log breakfast", "meal_log"),
    ("Complete a 30-minute walk", "exercise"),
  ];

  Future<void> _assignTask(String title, String type) async {
    final controller = context.read<TaskController>();

    final success = await controller.assignTask(
      widget.enrollmentId,
      AssignTaskRequest(title: title, type: type),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Task assigned."
              : controller.state.errorMessage ?? "Failed to assign task.",
        ),
      ),
    );
  }

  Future<void> _assignCustomTask() async {
    final title = _customTaskController.text.trim();

    if (title.isEmpty) return;

    await _assignTask(title, "custom");

    _customTaskController.clear();
  }

  Future<void> _addNote() async {
    final body = _noteController.text.trim();

    if (body.isEmpty) return;

    final controller = context.read<NoteController>();

    final success = await controller.addNote(widget.enrollmentId, body);

    if (!mounted) return;

    if (success) {
      _noteController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.state.errorMessage ?? "Failed to add note."),
        ),
      );
    }
  }

  Future<void> _openConversation(String clientName) async {
    final conversationId = await context
        .read<ConversationController>()
        .startSpecialistConversation(widget.enrollmentId);

    if (!mounted) return;

    if (conversationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open conversation.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageThreadScreen(
          conversationId: conversationId,
          isSpecialist: true,
          otherPartyName: clientName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Consumer<ClientController>(
          builder: (context, controller, child) {
            final state = controller.state;
            final detail = state.clientDetail;

            return BlurryModalProgressHUD(
              inAsyncCall: state.isLoadingDetail,
              blurEffectIntensity: 7,
              progressIndicator: SpinKitFadingCircle(
                color: AppColors.primaryBtn,
                size: 90.0.w,
              ),
              dismissible: false,
              opacity: 0.2,
              color: AppColors.blobs1,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: detail == null
                      ? _buildLoadingOrError(state.errorMessage)
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                  Expanded(child: Text1(detail.clientName)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text2(
                                  detail.currentWeek != null &&
                                          detail.durationWeeks != null
                                      ? "${detail.programName} · Week ${detail.currentWeek} of ${detail.durationWeeks}"
                                      : detail.programName,
                                ),
                              ),
                              const SizedBox(height: 20),

                              //---------------------------------------------------
                              // Actions
                              //---------------------------------------------------
                              Row(
                                children: [
                                  Expanded(
                                    child: Button2(
                                      "Message",
                                      () => _openConversation(detail.clientName),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Button1(
                                      "Start Session",
                                      () => _openConversation(detail.clientName),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),

                              //---------------------------------------------------
                              // Assigned Tasks
                              //---------------------------------------------------
                              Text4("Assigned Tasks"),
                              const SizedBox(height: 12),
                              _buildAssignTask(),
                              const SizedBox(height: 28),

                              //---------------------------------------------------
                              // Notes
                              //---------------------------------------------------
                              Text4("Notes"),
                              const SizedBox(height: 12),
                              _buildNotes(),
                              const SizedBox(height: 28),

                              //---------------------------------------------------
                              // Assessment History
                              //---------------------------------------------------
                              Text4("Assessment History (DASS-21)"),
                              const SizedBox(height: 12),
                              _buildAssessmentHistory(state.clientAssessments),
                              const SizedBox(height: 28),

                              //---------------------------------------------------
                              // Vitals & Data
                              //---------------------------------------------------
                              Text4("Vitals & Data"),
                              const SizedBox(height: 12),
                              _buildVitals(state),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingOrError(String? errorMessage) {
    if (errorMessage != null) {
      return Center(child: Text2(errorMessage));
    }

    return const SizedBox.shrink();
  }

  //---------------------------------------------------
  // Assign Task
  //---------------------------------------------------

  Widget _buildAssignTask() {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        final tasks = controller.state.clientTasks;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetTasks.map((preset) {
                final (title, type) = preset;

                return ActionChip(
                  backgroundColor: AppColors.white,
                  label: Text(title),
                  onPressed: controller.state.isAssigning
                      ? null
                      : () => _assignTask(title, type),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _customTaskController,
                    hintText: "Custom task",
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: controller.state.isAssigning
                      ? null
                      : _assignCustomTask,
                  icon: const Icon(Icons.add_circle, color: AppColors.primaryBtn),
                ),
              ],
            ),
            if (tasks.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...tasks.map(_buildTaskRow),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTaskRow(ClientTaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            task.isCompleted
                ? Icons.check_circle_outline
                : Icons.radio_button_unchecked,
            size: 18,
            color: task.isCompleted ? AppColors.primaryBtn : AppColors.bodyText,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text2(
              task.title,
              textAlign: TextAlign.left,
            ),
          ),
          Text(
            task.isCompleted ? "Completed" : "Pending",
            style: TextStyle(
              fontSize: 11.sp,
              color: task.isCompleted ? AppColors.primaryBtn : AppColors.bodyText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------
  // Notes
  //---------------------------------------------------

  Widget _buildNotes() {
    return Consumer<NoteController>(
      builder: (context, controller, child) {
        final notes = controller.state.notes;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _noteController,
                    hintText: "Add a note about this client",
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: controller.state.isSubmitting ? null : _addNote,
                  icon: const Icon(Icons.add_circle, color: AppColors.primaryBtn),
                ),
              ],
            ),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...notes.map(_buildNoteRow),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNoteRow(NoteModel note) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text2(note.body),
          if (note.createdAt != null) ...[
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM d, y').format(note.createdAt!),
              style: TextStyle(fontSize: 11.sp, color: AppColors.bodyText),
            ),
          ],
        ],
      ),
    );
  }

  //---------------------------------------------------
  // Assessment History
  //---------------------------------------------------

  Widget _buildAssessmentHistory(AssessmentDashboardResponse? assessments) {
    final history = assessments?.history ?? [];

    if (history.isEmpty) {
      return Text2("No assessments submitted yet.");
    }

    return Column(
      children: history.reversed.map((item) {
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
                    Text2(
                      DateFormat('MMM d, y').format(item.submittedAt),
                    ),
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

  //---------------------------------------------------
  // Vitals
  //---------------------------------------------------

  Widget _buildVitals(ClientState state) {
    final vitals = state.clientVitals;

    if (vitals == null) {
      return Text2("No vitals recorded yet.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MeasurementCard(
          "BMI",
          vitals.bmi.value != null
              ? "${vitals.bmi.value} ${vitals.bmi.unit}"
              : "Not recorded",
          "⚖️",
          () {},
        ),
        const SizedBox(height: 10),
        MeasurementCard(
          "Heart Rate",
          vitals.heartRate.value != null
              ? "${vitals.heartRate.value?.toInt()} ${vitals.heartRate.unit}"
              : "Not recorded",
          "❤️",
          () {},
        ),
        const SizedBox(height: 10),
        MeasurementCard(
          "Blood Pressure",
          vitals.bloodPressure.systolic != null
              ? "${vitals.bloodPressure.systolic?.toInt()}/${vitals.bloodPressure.diastolic?.toInt()} ${vitals.bloodPressure.unit}"
              : "Not recorded",
          "🩸",
          () {},
        ),
        if (vitals.bloodPressureChart.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text2("Blood Pressure History"),
          const SizedBox(height: 8),
          ChartBloodPressure(data: vitals.bloodPressureChart),
        ],
        if (vitals.heartRateChart.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text2("Heart Rate History"),
          const SizedBox(height: 8),
          ChartHeartRate(data: vitals.heartRateChart),
        ],
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientController>().loadClientProfile(widget.enrollmentId);
      context.read<TaskController>().loadClientTasks(widget.enrollmentId);
      context.read<NoteController>().loadClientNotes(widget.enrollmentId);
    });
  }

  @override
  void dispose() {
    _customTaskController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
