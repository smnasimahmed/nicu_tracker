// lib/features/ambulance/controllers/ambulance_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/ambulance_model.dart';
import '../../../data/models/user_model.dart';
import '../../auth/controllers/auth_controller.dart';

class AmbulanceController extends GetxController {
  int currentTabIndex = 0;
  List<AmbulanceModel> ambulances = List.from(DummyData.ambulances);

  // Profile editing
  late UserModel profileData;

  @override
  void onInit() {
    super.onInit();
    profileData = Get.find<AuthController>().currentUser!;
  }

  // Stats
  int get totalRegistered => ambulances.length;
  int get activeCount =>
      ambulances.where((a) => a.status == AmbulanceStatus.active).length;
  int get inactiveCount =>
      ambulances.where((a) => a.status == AmbulanceStatus.inactive).length;

  void changeTab(int index) {
    currentTabIndex = index;
    update();
  }

  // ─── Toggle Status ────────────────────────────────────────────────────────

  void toggleStatus(String id) {
    final idx = ambulances.indexWhere((a) => a.id == id);
    if (idx == -1) return;
    final current = ambulances[idx].status;
    ambulances[idx] = ambulances[idx].copyWith(
      status: current == AmbulanceStatus.active
          ? AmbulanceStatus.inactive
          : AmbulanceStatus.active,
    );
    update();
  }

  // ─── Add Ambulance ────────────────────────────────────────────────────────

  void addAmbulance({
    required String registrationNumber,
    required String vehicleName,
    required bool hasNicuFacility,
    required List<String> serviceAreas,
  }) {
    final newAmb = AmbulanceModel(
      id: 'amb_${DateTime.now().millisecondsSinceEpoch}',
      registrationNumber: registrationNumber,
      vehicleName: vehicleName,
      hasNicuFacility: hasNicuFacility,
      serviceAreas: serviceAreas,
      status: AmbulanceStatus.active,
      agencyName: profileData.organizationName,
    );
    ambulances.add(newAmb);
    update();
    Get.back();
    Get.snackbar(
      AppStrings.ambulanceSavedSuccess,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─── Edit Ambulance ───────────────────────────────────────────────────────

  void editAmbulance({
    required String id,
    required String registrationNumber,
    required String vehicleName,
    required bool hasNicuFacility,
    required List<String> serviceAreas,
  }) {
    final idx = ambulances.indexWhere((a) => a.id == id);
    if (idx == -1) return;
    ambulances[idx] = ambulances[idx].copyWith(
      registrationNumber: registrationNumber,
      vehicleName: vehicleName,
      hasNicuFacility: hasNicuFacility,
      serviceAreas: serviceAreas,
    );
    update();
    Get.back();
    Get.snackbar(
      AppStrings.ambulanceSavedSuccess,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─── Update Profile ───────────────────────────────────────────────────────

  void updateProfile({required String name, required String phone, required String address}) {
    profileData = profileData.copyWith(name: name, phone: phone, address: address);
    update();
    Get.snackbar(
      'Profile saved!',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }
}
