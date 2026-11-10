import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/chart_blood_pressure.dart';
import 'package:betteryou_co/components/chart_heart_rate.dart';
import 'package:betteryou_co/components/measurement_cards.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/core/auth/session_manager.dart';
import 'package:betteryou_co/data/wellness_score_calculator.dart';
import 'package:betteryou_co/models/bmi_request.dart';
import 'package:betteryou_co/models/heart_rate_request.dart';
import 'package:betteryou_co/screens/premium_user/assessment_history_screen.dart';
import 'package:betteryou_co/screens/guest_user/dass_question_screen.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
import 'package:betteryou_co/screens/shared/signup_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/app_bottom_nav.dart';
import '../../components/app_fab.dart';
import '../../components/assesment_card.dart';
import '../../components/button_1.dart';
import '../../components/button_2.dart';
import '../../components/chart_card.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/gauage_dount.dart';
import '../../components/gauage_dount_2.dart';
import '../../components/health_log_datetime.dart';
import '../../components/health_log_input.dart';
import '../../components/health_log_sheet.dart';
import '../../components/health_log_sheet_header.dart';
import '../../components/summary_card.dart';
import '../../components/task_tile.dart';
import '../../components/text_2.dart';
import '../../components/text_4.dart';
import 'package:intl/intl.dart';

import '../../core/auth/controllers/auth_controller.dart';
import '../../core/health/controllers/health_controller.dart';
import '../../core/helpers/chart_scale_bloodpressure.dart';
import '../../core/stress_assessment/controllers/assessment_controller.dart';
import '../../core/task/task_controller.dart';
import '../../models/assessment_model.dart';
import '../../models/blood_pressure_request.dart';
import '../../models/chart_point_blood_pressure.dart';
import '../../models/client_task_model.dart';
import '../../models/sleep_request.dart';
import '../../models/task_model.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => HealthScreenState();
}

class HealthScreenState extends State<HealthScreen> {
  String userName = "";
  DateTime selectedDate = DateTime.now();
  int currentIndex = 0;
  int selectedIndex = 0;

  DateTime healthInputDate = DateTime.now();
  TimeOfDay healthInputTime = TimeOfDay.now();

  DateTime get _combinedHealthInputDateTime => DateTime(
        healthInputDate.year,
        healthInputDate.month,
        healthInputDate.day,
        healthInputTime.hour,
        healthInputTime.minute,
      );

  DateTime sleepStartDate = DateTime.now().subtract(const Duration(days: 1));
  TimeOfDay sleepStartTime = const TimeOfDay(hour: 23, minute: 0);
  DateTime sleepEndDate = DateTime.now();
  TimeOfDay sleepEndTime = const TimeOfDay(hour: 7, minute: 0);

  final sysController = TextEditingController();
  final diaController = TextEditingController();

  final bpmController = TextEditingController();

  final heightController = TextEditingController();
  final weightController = TextEditingController();

  final _formKeyBP = GlobalKey<FormState>();
  final _formKeyHR = GlobalKey<FormState>();
  final _formKeyBMI = GlobalKey<FormState>();

  TaskModel _toTaskModel(ClientTaskModel task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      time: task.isCompleted ? "Done" : "Today",
      status: task.isCompleted ? TaskStatus.completed : TaskStatus.pending,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthController>(
      builder: (context, healthController, child) {
        final summary = healthController.state.summary;
        final latestAssessment =
            context.watch<AssessmentController>().state.dashboard?.latest;
        final scaleBP = calculateBloodPressureScale(
          summary?.bloodPressureChart ?? [],
        );

        final wellnessScore = WellnessScoreCalculator.calculate(
          bmi: summary?.bmi.value,
          diastolicBP: summary?.bloodPressure.diastolic?.toInt(),
          systolicBP: summary?.bloodPressure.systolic?.toInt(),
          restingHeartRate: summary?.heartRate.value?.toInt(),
          sleepHours: summary?.sleep?.value,
          dassScore: latestAssessment?.score,
        );

        final mentalState = WellnessScoreCalculator.mentalState(
          latestAssessment?.interpretation,
        );

        final validationErrors = healthController.state.validationErrors;
        final errors = healthController.state.errorMessage;

        return BlurryModalProgressHUD(
          inAsyncCall: healthController.state.isLoading,
          blurEffectIntensity: 7,
          progressIndicator: SpinKitFadingCircle(
            color: AppColors.primaryBtn,
            size: 90.0.w,
          ),
          dismissible: false,
          opacity: 0.2,
          color: AppColors.blobs1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.person_pin, size: 48),
                  title: Text2("Hello 👋"),
                  subtitle: Text4(userName ?? 'Guest'),
                  trailing: InkWell(child: Icon(Icons.logout), onTap: _logout),
                ),
                SizedBox(height: 20.h),
                Text1("How are you feeling, today?"),

                EasyDateTimeLine(
                  headerProps: EasyHeaderProps(
                    monthPickerType: MonthPickerType.switcher,
                    dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
                  ),
                  initialDate: selectedDate,
                  onDateChange: (date) {
                    setState(() {
                      selectedDate = date;
                    });

                    _changeDate();
                  },

                  activeColor: AppColors.secondaryBtn,
                  dayProps: EasyDayProps(
                    height: 70,
                    width: 60,
                    dayStructure: DayStructure.dayStrDayNum,
                    activeDayStyle: DayStyle(
                      dayStrStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      dayNumStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    inactiveDayStyle: DayStyle(
                      dayStrStyle: TextStyle(fontSize: 14.sp),
                      dayNumStyle: TextStyle(fontSize: 14.sp),
                    ),
                    todayStyle: DayStyle(
                      dayStrStyle: TextStyle(fontSize: 14.sp),
                      dayNumStyle: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),

                SizedBox(height: 16.sp),
                Center(child: stressGauge2(wellnessScore, mentalState)),
                SizedBox(height: 16.sp),
                Row(
                  children: [
                    SummaryCard(
                      icon: Icons.favorite_outline,
                      iconColor: Color(0xff8A5B3D),
                      title: "Wellness Score",
                      value: "",
                      suffix: "$wellnessScore",
                      subtitle: "Based on BP, HR, BMI, sleep & DASS-21",
                    ),

                    SizedBox(width: 16),

                    SummaryCard(
                      icon: Icons.psychology_alt_outlined,
                      iconColor: Color(0xff8A5B3D),
                      title: "Mental State",
                      value: mentalState,
                      subtitle: latestAssessment != null
                          ? "From latest DASS-21"
                          : "Take an assessment",
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text4("Recent Assessments"),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AssessmentHistoryScreen(),
                            ),
                          );
                        },
                        child: AssessmentCard(
                          assessment: AssessmentModel(
                            title: "DASS-21",
                            score: latestAssessment?.score.toString() ?? "--",
                            change: 0,
                            scoreColor: Color(0xff008E7F),
                          ),
                        ),
                      ),
                      AssessmentCard(
                        assessment: AssessmentModel(
                          title: "Blood Pressure",
                          score:
                              "${summary?.bloodPressure.systolic ?? "--"} / ${summary?.bloodPressure.diastolic ?? "--"}",
                          change: 0,
                          scoreColor: Color(0xff8D7CBA),
                        ),
                      ),
                      AssessmentCard(
                        assessment: AssessmentModel(
                          title: "Heart Rate",
                          score: "${summary?.heartRate.value ?? "--"}",
                          change: 0,
                          scoreColor: Color(0xffDF9262),
                        ),
                      ),
                      // Add more fixed children as needed
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text4("Today’s  Program Tasks"),
                SizedBox(height: 8.h),
                Consumer<TaskController>(
                  builder: (context, taskController, child) {
                    final todayTasks = taskController.state.todayTasks;

                    if (todayTasks.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text2("No tasks assigned for today."),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        itemCount: todayTasks.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          indent: 52,
                          endIndent: 16,
                          color: Colors.grey.shade200,
                        ),
                        itemBuilder: (_, index) {
                          final task = todayTasks[index];

                          return TaskTile(
                            task: _toTaskModel(task),
                            onTap: task.isCompleted
                                ? null
                                : () => taskController.completeTask(task.id),
                          );
                        },
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.h),
                Text4("Health Snapshot"),
                SizedBox(height: 8),
                ChartCard(
                  title: 'Blood Pressure',

                  onViewAll: () {},

                  child: (summary?.bloodPressureChart ?? []).isEmpty
                      ? const SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              "No readings yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ChartBloodPressure(
                          minY: scaleBP.minY,
                          maxY: scaleBP.maxY,
                          data: summary?.bloodPressureChart ?? [],
                        ),
                ),
                SizedBox(height: 10),
                ChartCard(
                  title: 'Heart Rate',

                  onViewAll: () {},

                  child: (summary?.heartRateChart ?? []).isEmpty
                      ? const SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              "No readings yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ChartHeartRate(data: summary?.heartRateChart ?? []),
                ),
                SizedBox(height: 10),
                MeasurementCard(
                  "Sleep",
                  summary?.sleep?.value != null
                      ? "${summary!.sleep!.value!.toStringAsFixed(1)} hours last night"
                      : "No readings yet",
                  "😴",
                  () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final ValueNotifier<int> step = ValueNotifier(0);

  void showBottomSheet(BuildContext context) {
    step.value = 0;

    showModalBottomSheet(
      context: context,

      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.7),

      isScrollControlled: true,
      backgroundColor: Color(0xFFECECEC),
      builder: (context) {
        return Consumer<HealthController>(
          builder: (context, healthController, child) {
            return ValueListenableBuilder<int>(
              valueListenable: step,
              builder: (context, currentStep, _) {
                switch (currentStep) {
                  case 0:
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(40.r),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.close, size: 24),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                "Stay on Top of Your Health",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          const Text(
                            "Track your blood pressure, heart rate, BMI, and sleep to discover trends, build healthier habits, and take control of your well-being.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Image.asset(
                              "assets/images/measure.png",
                              width: 180,
                              height: 180,
                            ),
                          ),
                          SizedBox(height: 10),
                          const Text(
                            "Choose an option",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),

                          MeasurementCard(
                            "Blood Pressure",
                            "Measure your blood pressure",
                            "🩸",
                            () {
                              step.value = 1;
                            },
                          ),
                          MeasurementCard(
                            "Heart Rate",
                            "Measure your heart rate",
                            "❤️",
                            () {
                              step.value = 2;
                            },
                          ),
                          MeasurementCard(
                            "BMI",
                            "Find your Body Mass Index",
                            "⏲️",
                            () {
                              step.value = 3;
                            },
                          ),
                          MeasurementCard("Sleep", "Measure Sleep", "😴️", () {
                            step.value = 4;
                          }),
                        ],
                      ),
                    );

                  case 1:
                    return HealthLogSheet(
                      child: Column(
                        children: [
                          HealthSheetHeader(
                            title: "Blood Pressure",
                            onTap: () {
                              step.value = 0;
                            },
                          ),

                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: _formKeyBP,
                                child: Column(
                                  children: [
                                    HealthDateTimeField.date(
                                      date: healthInputDate,
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: healthInputDate,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            healthInputDate = picked;
                                          });
                                        }
                                      },
                                    ),

                                    const Divider(),

                                    HealthDateTimeField.time(
                                      time: healthInputTime,
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: healthInputTime,
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            healthInputTime = picked;
                                          });
                                        }
                                      },
                                    ),

                                    const Divider(),

                                    HealthInputField(
                                      "SYS",
                                      "e.g. 120",
                                      sysController,
                                      healthController.getFieldError("sys"),
                                    ),

                                    const Divider(),

                                    HealthInputField(
                                      "DIA",
                                      "e.g. 80",
                                      diaController,
                                      healthController.getFieldError("dia"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Button1("Save", () {
                            _saveBloodPressure();
                          }),
                        ],
                      ),
                    );

                  case 2:
                    return HealthLogSheet(
                      child: Column(
                        children: [
                          HealthSheetHeader(
                            title: "Heart Rate",
                            onTap: () {
                              step.value = 0;
                            },
                          ),

                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: _formKeyHR,
                                child: Column(
                                  children: [
                                    HealthDateTimeField.date(
                                      date: healthInputDate,
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: healthInputDate,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            healthInputDate = picked;
                                          });
                                        }
                                      },
                                    ),

                                    const Divider(),

                                    HealthDateTimeField.time(
                                      time: healthInputTime,
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: healthInputTime,
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            healthInputTime = picked;
                                          });
                                        }
                                      },
                                    ),

                                    const Divider(),

                                    HealthInputField(
                                      "BPM",
                                      "e.g. 75",
                                      bpmController,
                                      healthController.getFieldError("bpm"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Button1("Save", () {
                            _saveHeartRate();
                          }),
                        ],
                      ),
                    );

                  case 3:
                    return HealthLogSheet(
                      child: Column(
                        children: [
                          HealthSheetHeader(
                            title: "Body Mass Index",
                            onTap: () {
                              step.value = 0;
                            },
                          ),

                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: _formKeyBMI,
                                child: Column(
                                  children: [
                                    HealthDateTimeField.date(
                                      date: healthInputDate,
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: healthInputDate,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            healthInputDate = picked;
                                          });

                                          print("asa ${healthInputDate}");
                                        }
                                      },
                                    ),

                                    const Divider(),

                                    HealthDateTimeField.time(
                                      time: healthInputTime,
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: healthInputTime,
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            healthInputTime = picked;
                                          });
                                        }
                                      },
                                    ),

                                    const Divider(),

                                    HealthInputField(
                                      "Height (ft)",
                                      "e.g. 5.9",
                                      heightController,
                                      healthController.getFieldError("height"),
                                      allowDecimal: true,
                                    ),
                                    const Divider(),

                                    HealthInputField(
                                      "Weight (kg)",
                                      "e.g. 75",
                                      weightController,
                                      healthController.getFieldError("weight"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Button1("Save", () {
                            _saveBMI();
                          }),
                        ],
                      ),
                    );

                  case 4:
                    return HealthLogSheet(
                      child: StatefulBuilder(
                        builder: (context, setSheetState) {
                          return Column(
                            children: [
                              HealthSheetHeader(
                                title: "Sleep",
                                onTap: () {
                                  step.value = 0;
                                },
                              ),

                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      HealthDateTimeField.date(
                                        date: sleepStartDate,
                                        onTap: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: sleepStartDate,
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2100),
                                          );

                                          if (picked != null) {
                                            setSheetState(() {
                                              sleepStartDate = picked;
                                            });
                                          }
                                        },
                                      ),

                                      const Divider(),

                                      HealthDateTimeField.time(
                                        time: sleepStartTime,
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: sleepStartTime,
                                          );

                                          if (picked != null) {
                                            setSheetState(() {
                                              sleepStartTime = picked;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      HealthDateTimeField.date(
                                        date: sleepEndDate,
                                        onTap: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: sleepEndDate,
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2100),
                                          );

                                          if (picked != null) {
                                            setSheetState(() {
                                              sleepEndDate = picked;
                                            });
                                          }
                                        },
                                      ),

                                      const Divider(),

                                      HealthDateTimeField.time(
                                        time: sleepEndTime,
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: sleepEndTime,
                                          );

                                          if (picked != null) {
                                            setSheetState(() {
                                              sleepEndTime = picked;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              Button1(
                                "Save",
                                _saveSleep,
                                isLoading: healthController.state.isLoading,
                              ),
                            ],
                          );
                        },
                      ),
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            );
          },
        );
      },
    );
  }

  Future<void> _saveBloodPressure() async {
    FocusScope.of(context).unfocus();

    if (!_formKeyBP.currentState!.validate()) {
      return;
    }

    final controller = context.read<HealthController>();

    final request = BloodPressureRequest(
      recordedAt: _combinedHealthInputDateTime,
      systolic: int.parse(sysController.text.trim()),
      diastolic: int.parse(diaController.text.trim()),
    );

    final success = await controller.saveBloodPressure(request);

    if (!mounted) return;

    if (success) {
      print("BP - Submit Success");
      sysController.clear();
      diaController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.successMessage ?? "Blood Pressure saved successfully.",
          ),

          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);

      _changeDate();
    } else {
      if (controller.errorMessage != null &&
          controller.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage!),

            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveHeartRate() async {
    FocusScope.of(context).unfocus();

    if (!_formKeyHR.currentState!.validate()) {
      return;
    }

    final controller = context.read<HealthController>();

    final request = HeartRateRequest(
      recordedAt: _combinedHealthInputDateTime,
      bpm: int.parse(bpmController.text.trim()),
    );

    final success = await controller.saveHeartRate(request);

    if (!mounted) return;

    if (success) {
      bpmController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.successMessage ?? "Heart Rate saved successfully.",
          ),

          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
      _changeDate();
    } else {
      if (controller.errorMessage != null &&
          controller.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage!),

            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveBMI() async {
    FocusScope.of(context).unfocus();

    if (!_formKeyBMI.currentState!.validate()) {
      return;
    }

    final controller = context.read<HealthController>();

    // The field collects height in feet (decimal, e.g. "5.9") but
    // BMIRequest.bmi's formula assumes centimeters — convert here so the
    // stored/derived BMI is actually correct instead of silently using
    // the raw feet value as if it were centimeters.
    final heightFeet = double.parse(heightController.text.trim());
    final heightCm = heightFeet * 30.48;

    final request = BMIRequest(
      recordedAt: _combinedHealthInputDateTime,
      height: heightCm,
      weight: double.parse(weightController.text.trim()),
    );

    final success = await controller.saveBMI(request);

    if (!mounted) return;

    if (success) {
      heightController.clear();
      weightController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.successMessage ?? "BMI saved successfully."),

          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);

      _changeDate();
    } else {
      if (controller.errorMessage != null &&
          controller.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage!),

            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveSleep() async {
    final startsAt = DateTime(
      sleepStartDate.year,
      sleepStartDate.month,
      sleepStartDate.day,
      sleepStartTime.hour,
      sleepStartTime.minute,
    );

    final endsAt = DateTime(
      sleepEndDate.year,
      sleepEndDate.month,
      sleepEndDate.day,
      sleepEndTime.hour,
      sleepEndTime.minute,
    );

    if (!endsAt.isAfter(startsAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sleep end time must be after the start time."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final controller = context.read<HealthController>();

    final request = SleepRequest(startsAt: startsAt, endsAt: endsAt);

    final success = await controller.saveSleep(request);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.successMessage ?? "Sleep saved successfully."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);

      _changeDate();
    } else {
      if (controller.errorMessage != null &&
          controller.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadUser() async {
    final session = SessionManager.instance;
    final user = await session.getUser();

    setState(() {
      userName = user?['name'] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();

    _loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthController>().loadSummary(selectedDate);
      context.read<TaskController>().loadTodayTasks();
      context.read<AssessmentController>().loadDashboard(date: selectedDate);
    });
  }

  Future<void> _changeDate() async {
    context.read<HealthController>().loadSummary(selectedDate);
    context.read<AssessmentController>().loadDashboard(date: selectedDate);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final authController = context.read<AuthController>();

    await authController.logout();

    if (!mounted) return;

    SystemNavigator.pop();
  }
}
