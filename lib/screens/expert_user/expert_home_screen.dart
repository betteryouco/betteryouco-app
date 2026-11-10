import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/components/text_2.dart';
import 'package:betteryou_co/components/text_3.dart';
import 'package:betteryou_co/components/text_4.dart';
import 'package:betteryou_co/core/auth/session_manager.dart';
import 'package:betteryou_co/screens/shared/message_thread_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/assesment_card.dart';
import '../../core/auth/controllers/auth_controller.dart';
import '../../core/client/client_controller.dart';
import '../../core/specialist_dashboard/specialist_dashboard_controller.dart';
import '../../models/assessment_model.dart';
import '../../models/specialist_dashboard_model.dart';
import 'assignment_requests_screen.dart';

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({super.key});

  @override
  State<ExpertHomeScreen> createState() => ExpertHomeScreenState();
}

class ExpertHomeScreenState extends State<ExpertHomeScreen> {
  String userName = "";
  String? profilePicUrl;

  @override
  Widget build(BuildContext context) {
    // Kept live so other tabs (e.g. Clients) that mutate this count stay
    // in sync without needing a full dashboard reload.
    context.watch<ClientController>().state.activeClients.length;

    return Consumer<SpecialistDashboardController>(
      builder: (context, dashboardController, child) {
        final state = dashboardController.state;
        final dashboard = state.dashboard;

        return BlurryModalProgressHUD(
          inAsyncCall: state.isLoading && dashboard == null,
          blurEffectIntensity: 7,
          progressIndicator: SpinKitFadingCircle(
            color: AppColors.primaryBtn,
            size: 90.0.w,
          ),
          dismissible: false,
          opacity: 0.2,
          color: AppColors.blobs1,
          child: RefreshIndicator(
            onRefresh: () => dashboardController.loadDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildHeader(dashboard),

                  const SizedBox(height: 24),
                  Text4("Recent Assessments"),
                  const SizedBox(height: 8),
                  _buildTiles(dashboard),

                  const SizedBox(height: 24),
                  Text4("Earnings"),
                  const SizedBox(height: 8),
                  _buildEarningsBreakdown(dashboard),

                  const SizedBox(height: 24),
                  Text4("Today's Sessions"),
                  const SizedBox(height: 8),
                  _buildTodaySessions(dashboard),

                  const SizedBox(height: 24),
                  _buildSectionHeader("At-Risk Clients", warning: true),
                  const SizedBox(height: 8),
                  _buildAtRiskClients(dashboard),

                  const SizedBox(height: 24),
                  Text4("Pending Tasks"),
                  const SizedBox(height: 8),
                  _buildPendingTasks(dashboard),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //---------------------------------------------------
  // Header
  //---------------------------------------------------

  Widget _buildHeader(SpecialistDashboardModel? dashboard) {
    final subtitle = dashboard == null
        ? _timeOfDayGreeting()
        : "${dashboard.greeting.date} \n ${dashboard.greeting.sessionsToday} session${dashboard.greeting.sessionsToday == 1 ? '' : 's'} today";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text1("Hi, ${userName.isNotEmpty ? userName : 'there'}"),
            Text4(subtitle),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AssignmentRequestsScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBtn.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people_alt_outlined,
                    color: AppColors.primaryBtn,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _logout,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBtn.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout,
                    color: AppColors.primaryBtn,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ClipOval(
                child: (profilePicUrl != null && profilePicUrl!.isNotEmpty)
                    ? Image.network(
                        profilePicUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _profilePlaceholder(),
                      )
                    : _profilePlaceholder(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profilePlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primaryBtn.withOpacity(.15),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, color: AppColors.primaryBtn, size: 28),
    );
  }

  String _timeOfDayGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  //---------------------------------------------------
  // Tiles
  //---------------------------------------------------

  Widget _buildTiles(SpecialistDashboardModel? dashboard) {
    final tiles = dashboard?.tiles;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 6,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        AssessmentCard(
          assessment: AssessmentModel(
            title: "Active Clients",
            score: "${tiles?.activeClients ?? '--'}",
            change: 0,
            scoreColor: const Color(0xff1E2C2F),
            caption: tiles?.activeClientsCaption,
            showTrendIcon: false,
          ),
        ),
        AssessmentCard(
          assessment: AssessmentModel(
            title: "This Week",
            score: "${tiles?.sessionsThisWeek ?? '--'}",
            change: 0,
            scoreColor: const Color(0xff1E2C2F),
            caption: tiles?.sessionsThisWeekCaption,
            showTrendIcon: false,
          ),
        ),
        AssessmentCard(
          assessment: AssessmentModel(
            title: "Avg DASS-21",
            score: tiles?.avgStressTrend != null
                ? tiles!.avgStressTrend!.toStringAsFixed(1)
                : "-- ",
            change: tiles?.avgStressTrend != null
                ? tiles!.avgStressTrend!.round()
                : 0,
            scoreColor: const Color(0xff1E2C2F),
            caption: tiles?.avgStressTrendCaption,
          ),
        ),
        AssessmentCard(
          assessment: AssessmentModel(
            title: "Earnings",
            score: tiles != null
                ? "\$${tiles.earningsTotal.toStringAsFixed(0)}"
                : "--",
            change: tiles?.earningsTrendPct != null
                ? tiles!.earningsTrendPct!.round()
                : 0,
            scoreColor: const Color(0xff1E2C2F),
            caption: tiles?.earningsCaption,
            showTrendIcon: tiles?.earningsTrendPct != null,
          ),
        ),
      ],
    );
  }

  //---------------------------------------------------
  // Earnings breakdown (pending / available / paid + payout history)
  //---------------------------------------------------

  Widget _buildEarningsBreakdown(SpecialistDashboardModel? dashboard) {
    final earnings = dashboard?.earnings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _earningsStat("Pending", earnings?.pending, AppColors.tags8),
              _earningsStat("Available", earnings?.available, AppColors.icon2),
              _earningsStat("Paid", earnings?.paid, AppColors.icon1),
            ],
          ),
          if (earnings != null && earnings.recentPayouts.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.outline),
            const SizedBox(height: 12),
            Text2("Recent payouts"),
            const SizedBox(height: 8),
            ...earnings.recentPayouts
                .take(3)
                .map(
                  (payout) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text2(
                          payout.status == 'paid' ? 'Paid' : 'Pending approval',
                        ),
                        Text(
                          "\$${payout.amount.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1E2C2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  Widget _earningsStat(String label, double? value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\$${(value ?? 0).toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text2(label),
        ],
      ),
    );
  }

  //---------------------------------------------------
  // Today's Sessions
  //---------------------------------------------------

  Widget _buildTodaySessions(SpecialistDashboardModel? dashboard) {
    final sessions = dashboard?.todaySessions ?? [];

    if (sessions.isEmpty) {
      return _emptyCard("No sessions scheduled for today.");
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: sessions.asMap().entries.map((entry) {
          final isLast = entry.key == sessions.length - 1;
          final session = entry.value;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(bottom: BorderSide(color: AppColors.outline)),
            ),
            child: Row(
              children: [
                Text(
                  session.time,
                  style: TextStyle(fontSize: 13.sp, color: AppColors.bodyText),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text4(session.clientName),
                      const SizedBox(height: 2),
                      Text(
                        session.type,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.bodyText,
                        ),
                      ),
                    ],
                  ),
                ),
                _sessionStatusBadge(session),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sessionStatusBadge(TodaySessionModel session) {
    String label;
    Color color;

    switch (session.status) {
      case 'done':
        label = 'Done';
        color = AppColors.bodyText;
        break;
      case 'soon':
        label = session.minutesUntil != null
            ? 'In ${session.minutesUntil} mins'
            : 'Soon';
        color = AppColors.primaryBtn;
        break;
      default:
        label = session.time;
        color = AppColors.bodyText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  //---------------------------------------------------
  // At-Risk Clients
  //---------------------------------------------------

  Widget _buildSectionHeader(String title, {bool warning = false}) {
    return Row(
      children: [
        if (warning) ...[
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 18,
          ),
          const SizedBox(width: 6),
        ],
        Text4(title),
      ],
    );
  }

  Widget _buildAtRiskClients(SpecialistDashboardModel? dashboard) {
    final alerts = dashboard?.atRiskClients ?? [];

    if (alerts.isEmpty) {
      return _emptyCard("No at-risk clients right now.");
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: alerts.asMap().entries.map((entry) {
          final isLast = entry.key == alerts.length - 1;
          final alert = entry.value;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(bottom: BorderSide(color: AppColors.outline)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _severityColor(alert.severity),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text4("${alert.clientName} — ${alert.message}")],
                  ),
                ),
                if (alert.firedAt != null)
                  Text(
                    "${alert.firedAt!.month}/${alert.firedAt!.day}",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.bodyText,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  //---------------------------------------------------
  // Pending Tasks
  //---------------------------------------------------

  Widget _buildPendingTasks(SpecialistDashboardModel? dashboard) {
    final tasks = dashboard?.pendingTasks ?? [];

    if (tasks.isEmpty) {
      return _emptyCard("You're all caught up.");
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: tasks.asMap().entries.map((entry) {
          final isLast = entry.key == tasks.length - 1;
          final task = entry.value;

          final tappable =
              task.type == 'message' && task.conversationId != null;

          return InkWell(
            borderRadius: isLast
                ? BorderRadius.vertical(bottom: Radius.circular(16.r))
                : BorderRadius.zero,
            onTap: tappable
                ? () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MessageThreadScreen(
                          conversationId: task.conversationId!,
                          isSpecialist: true,
                          otherPartyName: task.clientName ?? 'Client',
                        ),
                      ),
                    );

                    if (mounted) {
                      context
                          .read<SpecialistDashboardController>()
                          .loadDashboard();
                    }
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(bottom: BorderSide(color: AppColors.outline)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.type == 'message'
                          ? AppColors.supportingText3
                          : AppColors.primaryBtn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text4(task.label),
                        const SizedBox(height: 2),
                        Text(
                          task.subtitle,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (tappable)
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.bodyText,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //---------------------------------------------------
  // Shared
  //---------------------------------------------------

  Widget _emptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 13.sp, color: AppColors.bodyText),
      ),
    );
  }

  //---------------------------------------------------
  // Lifecycle
  //---------------------------------------------------

  Future<void> _loadUser() async {
    final session = SessionManager.instance;
    final user = await session.getUser();

    if (!mounted) return;

    setState(() {
      userName = user?['name'] ?? '';
      profilePicUrl = user?['profile_pic_url'];
    });
  }

  @override
  void initState() {
    super.initState();

    _loadUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientController>().loadActiveClients();
      context.read<SpecialistDashboardController>().loadDashboard();
    });
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
