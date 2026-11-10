import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/app_background.dart';
import '../../components/button_1.dart';
import '../../components/button_2.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../components/text_4.dart';
import '../../core/purchase/purchase_controller.dart';
import '../../models/payment_model.dart';
import '../../models/program_model.dart';
import '../../theme/app_colors.dart';
import 'my_program_screen.dart';

/// Program purchase flow: summary -> confirm -> "Confirm Payment" (a mock
/// step standing in for Stripe checkout until test-mode keys are wired in)
/// -> hands off to the assignment-status screen.
class ProgramCheckoutScreen extends StatefulWidget {
  final ProgramModel program;

  const ProgramCheckoutScreen({super.key, required this.program});

  @override
  State<ProgramCheckoutScreen> createState() => _ProgramCheckoutScreenState();
}

class _ProgramCheckoutScreenState extends State<ProgramCheckoutScreen> {
  PaymentModel? _payment;

  String get _durationLabel {
    final min = widget.program.durationWeeks;
    final max = widget.program.durationWeeksMax;

    if (min == null) return "Duration to be confirmed";
    if (max == null || max == min) return "$min weeks";
    return "$min–$max weeks";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseController>(
      builder: (context, controller, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AppBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                            child: const Center(child: Icon(Icons.close, size: 24)),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(child: Text1("Confirm Your Program")),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text4(widget.program.title),
                          SizedBox(height: 6.h),
                          if (widget.program.description != null)
                            Text2(widget.program.description!),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.bodyText),
                              SizedBox(width: 6.w),
                              Text2(_durationLabel),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Container(height: 1, color: AppColors.outline),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text2("Total"),
                              Text(
                                "${widget.program.currency ?? ''} ${widget.program.price?.toStringAsFixed(0) ?? '—'}",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.headingText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text2(
                      "You'll pay BetterYou directly. Once payment is confirmed, "
                      "we'll match you with a specialist — you'll see their name "
                      "here as soon as they accept.",
                    ),

                    SizedBox(height: 28.h),

                    if (_payment == null) ...[
                      Button1(
                        "Purchase — ${widget.program.currency ?? ''} ${widget.program.price?.toStringAsFixed(0) ?? '—'}",
                        () => _purchase(controller),
                        isLoading: controller.state.isLoading,
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.tags3,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 18, color: AppColors.tags1),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text2(
                                "Payment gateway isn't connected yet — tap below to simulate a successful payment.",
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Button1(
                        "Confirm Payment",
                        () => _confirmPayment(controller),
                        isLoading: controller.state.isLoading,
                      ),
                      SizedBox(height: 12.h),
                      Button2("Cancel", () => Navigator.pop(context)),
                    ],

                    if (controller.state.errorMessage != null) ...[
                      SizedBox(height: 12.h),
                      Text(
                        controller.state.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _purchase(PurchaseController controller) async {
    final success = await controller.purchase(widget.program.id);

    if (!mounted || !success) return;

    setState(() => _payment = controller.state.currentPayment);
  }

  Future<void> _confirmPayment(PurchaseController controller) async {
    final payment = _payment;
    if (payment == null) return;

    final success = await controller.confirmMockPayment(payment.id);

    if (!mounted || !success) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyProgramScreen()),
    );
  }
}
