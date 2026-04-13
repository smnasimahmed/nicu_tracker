// lib/features/auth/controllers/auth_controller.dart
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/user_model.dart';

class AuthController extends GetxController {
  UserModel? currentUser;
  UserRole? selectedRole;
  bool isLoading = false;

  void selectRole(UserRole role) {
    selectedRole = role;
    update();
    Get.toNamed(AppRoutes.login, arguments: role);
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    update();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Dummy login — match by role
    switch (selectedRole) {
      case UserRole.hospital:
        currentUser = DummyData.hospitalUser;
        isLoading = false;
        update();
        Get.offAllNamed(AppRoutes.hospitalMain);
        break;
      case UserRole.ambulance:
        currentUser = DummyData.ambulanceUser;
        isLoading = false;
        update();
        Get.offAllNamed(AppRoutes.ambulanceMain);
        break;
      case UserRole.patient:
        currentUser = DummyData.patientUser;
        isLoading = false;
        update();
        Get.offAllNamed(AppRoutes.patientMain);
        break;
      default:
        isLoading = false;
        update();
    }
  }

  void logout() {
    currentUser = null;
    selectedRole = null;
    Get.offAllNamed(AppRoutes.roleSelect);
  }
}
