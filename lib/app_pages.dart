// lib/app_pages.dart
import 'package:get/get.dart';
import 'features/ambulance/controllers/ambulance_controller.dart';
import 'features/ambulance/screens/ambulance_main_screen.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/role_select_screen.dart';
import 'features/hospital/controllers/hospital_controller.dart';
import 'features/hospital/screens/hospital_main_screen.dart';
import 'features/patient/controllers/patient_controller.dart';
import 'features/patient/screens/patient_main_screen.dart';
import 'features/patient/screens/patient_register_screen.dart';
import 'core/constants/app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.roleSelect,
      page: () => const RoleSelectScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.hospitalMain,
      page: () => const HospitalMainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HospitalController>(() => HospitalController(),
            fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.ambulanceMain,
      page: () => const AmbulanceMainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AmbulanceController>(() => AmbulanceController(),
            fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.patientMain,
      page: () => const PatientMainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PatientController>(() => PatientController(),
            fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.patientRegister,
      page: () => const PatientRegisterScreen(),
    ),
  ];
}
