// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nicu_tracker/app_pages.dart';
import 'package:nicu_tracker/core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/connectivity_controller.dart';
import 'features/auth/controllers/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for mobile
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const NicuTrackerApp());
}

class NicuTrackerApp extends StatelessWidget {
  const NicuTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NICU Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.roleSelect,
      getPages: AppPages.pages,
      initialBinding: BindingsBuilder(() {
        // Global controllers — always alive
        Get.put<ConnectivityController>(ConnectivityController(),
            permanent: true);
        Get.put<AuthController>(AuthController(), permanent: true);
      }),
      defaultTransition: Transition.cupertino,
    );
  }
}
