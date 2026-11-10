import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/client_card.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../core/client/client_controller.dart';
import '../../theme/app_colors.dart';
import 'expert_client_detail_screen.dart';

class ExpertClientsScreen extends StatefulWidget {
  const ExpertClientsScreen({super.key});

  @override
  State<ExpertClientsScreen> createState() => ExpertClientsScreenState();
}

class ExpertClientsScreenState extends State<ExpertClientsScreen> {
  int _tabIndex = 0;

  void _selectTab(int index) {
    if (_tabIndex == index) return;

    setState(() => _tabIndex = index);

    final controller = context.read<ClientController>();

    if (index == 0) {
      controller.loadActiveClients();
    } else if (index == 1) {
      controller.loadAtRiskClients();
    } else {
      controller.loadCompletedClients();
    }
  }

  void _openClient(int enrollmentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExpertClientDetailScreen(enrollmentId: enrollmentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientController>(
      builder: (context, controller, child) {
        final state = controller.state;

        final clients = switch (_tabIndex) {
          0 => state.activeClients,
          1 => state.atRiskClients,
          _ => state.completedClients,
        };

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
              Text1("My Clients"),
              const SizedBox(height: 4),
              Text2("Clients enrolled in your programs."),
              const SizedBox(height: 16),
              _buildSegmentedControl(),
              const SizedBox(height: 16),
              Expanded(
                child: clients.isEmpty && !state.isLoadingList
                    ? Center(
                        child: Text2(switch (_tabIndex) {
                          0 => "No active clients yet.",
                          1 => "No at-risk clients right now.",
                          _ => "No completed clients yet.",
                        }),
                      )
                    : RefreshIndicator(
                        onRefresh: () => switch (_tabIndex) {
                          0 => controller.loadActiveClients(),
                          1 => controller.loadAtRiskClients(),
                          _ => controller.loadCompletedClients(),
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: clients.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final client = clients[index];

                            return ClientCard(
                              client: client,
                              onTap: () => _openClient(client.enrollmentId),
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

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Expanded(child: _segment("Active", 0)),
          Expanded(child: _segment("At-Risk", 1)),
          Expanded(child: _segment("Completed", 2)),
        ],
      ),
    );
  }

  Widget _segment(String label, int index) {
    final selected = _tabIndex == index;

    return GestureDetector(
      onTap: () => _selectTab(index),
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
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
