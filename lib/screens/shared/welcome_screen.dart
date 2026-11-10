import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/screens/premium_user/home_screen.dart';
import 'package:betteryou_co/screens/shared/login_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../components/button_1.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/text_2.dart';
import '../../core/auth/controllers/auth_controller.dart';
import '../../core/auth/session_manager.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AppBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 217.w,
                          height: 57.h,
                        ),
                        SizedBox(height: 40.h),
                        Text1("Welcome to BetterYou Co"),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text1("Choose how you'd like to continue"),
                        SizedBox(height: 40.h),
                        Button1("Continue as Patient", () {
                          userType('client');
                        }),
                        SizedBox(height: 20.h),
                        Button1("Continue as Expert", () {
                          userType('specialist');
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  userType(String type) async {
    await _storage.write(key: 'user_type', value: type);

    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
