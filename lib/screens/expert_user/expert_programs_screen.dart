import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/program_card.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../core/program/program_controller.dart';
import '../../theme/app_colors.dart';

/// Programs are fixed/predefined and admin-managed — a specialist can only
/// view what's been assigned to them, not create or edit programs.
class ExpertProgramsScreen extends StatefulWidget {
  const ExpertProgramsScreen({super.key});

  @override
  State<ExpertProgramsScreen> createState() => ExpertProgramsScreenState();
}

class ExpertProgramsScreenState extends State<ExpertProgramsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramController>(
      builder: (context, controller, child) {
        final state = controller.state;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text1("My Programs"),
              const SizedBox(height: 4),
              Text2("Programs assigned to you by the admin."),
              const SizedBox(height: 20),

              Expanded(
                child: state.programs.isEmpty && !state.isLoading
                    ? Center(
                        child: Text2("No programs have been assigned to you yet."),
                      )
                    : RefreshIndicator(
                        onRefresh: () => controller.loadMyPrograms(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.programs.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return ProgramCard(program: state.programs[index]);
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
