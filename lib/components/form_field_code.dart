import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class AppTextFormFieldCode extends StatelessWidget {
  ValueChanged onComplete;
  final TextEditingController? controller;

  AppTextFormFieldCode({
    super.key,
    required this.onComplete,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 52,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
    );

    return Pinput(
      controller: controller,
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyDecorationWith(
        border: Border.all(color: Colors.brown, width: 1),
      ),
      submittedPinTheme: defaultPinTheme,
      onCompleted: onComplete,
    );
  }
}
