import 'package:betteryou_co/core/client/client_controller.dart';
import 'package:betteryou_co/core/client/client_service.dart';
import 'package:betteryou_co/core/guest/guest_service.dart';
import 'package:betteryou_co/core/health/controllers/health_controller.dart';
import 'package:betteryou_co/core/health/services/health_service.dart';
import 'package:betteryou_co/core/messaging/conversation_controller.dart';
import 'package:betteryou_co/core/messaging/conversation_service.dart';
import 'package:betteryou_co/core/note/note_controller.dart';
import 'package:betteryou_co/core/note/note_service.dart';
import 'package:betteryou_co/core/assignment/assignment_controller.dart';
import 'package:betteryou_co/core/assignment/assignment_service.dart';
import 'package:betteryou_co/core/profile/ProfileeController.dart';
import 'package:betteryou_co/core/profile/profile_service.dart';
import 'package:betteryou_co/core/program/program_controller.dart';
import 'package:betteryou_co/core/program/program_service.dart';
import 'package:betteryou_co/core/purchase/purchase_controller.dart';
import 'package:betteryou_co/core/purchase/purchase_service.dart';
import 'package:betteryou_co/core/review/review_controller.dart';
import 'package:betteryou_co/core/review/review_service.dart';
import 'package:betteryou_co/core/specialist_dashboard/specialist_dashboard_controller.dart';
import 'package:betteryou_co/core/specialist_dashboard/specialist_dashboard_service.dart';
import 'package:betteryou_co/core/stress_assessment/controllers/assessment_controller.dart';
import 'package:betteryou_co/core/stress_assessment/services/assessment_service.dart';
import 'package:betteryou_co/core/task/task_controller.dart';
import 'package:betteryou_co/core/task/task_service.dart';
import 'package:betteryou_co/screens/expert_user/expert_main_screen.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
import 'package:betteryou_co/screens/premium_user/home_screen.dart';
import 'package:betteryou_co/screens/premium_user/profile_controller.dart';
import 'package:betteryou_co/screens/premium_user/profile_screen.dart';
import 'package:betteryou_co/screens/shared/login_screen.dart';
import 'package:betteryou_co/screens/shared/splash_screen.dart';
import 'package:betteryou_co/screens/shared/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/auth/controllers/auth_controller.dart';
import 'core/auth/services/auth_service.dart';
import 'core/guest/guest_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The whole app is designed portrait-only (fixed layouts throughout,
  // no landscape variants) — lock orientation at the Flutter level so it
  // holds on every platform regardless of manifest/plist settings.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(AuthService())),
        ChangeNotifierProvider(create: (_) => GuestController()),
        ChangeNotifierProvider(
          create: (_) => HealthController(HealthService()),
        ),
        ChangeNotifierProvider(
          create: (_) => AssessmentController(AssessmentService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileeController(ProfileService()),
        ),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(
          create: (_) => ProgramController(ProgramService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientController(ClientService()),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskController(TaskService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ConversationController(ConversationService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ReviewController(ReviewService()),
        ),
        ChangeNotifierProvider(
          create: (_) => NoteController(NoteService()),
        ),
        ChangeNotifierProvider(
          create: (_) => SpecialistDashboardController(SpecialistDashboardService()),
        ),
        ChangeNotifierProvider(
          create: (_) => PurchaseController(PurchaseService()),
        ),
        ChangeNotifierProvider(
          create: (_) => AssignmentController(AssignmentService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 794),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BetterYo Co',
          theme: ThemeData(
            textTheme: GoogleFonts.manropeTextTheme(),
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
