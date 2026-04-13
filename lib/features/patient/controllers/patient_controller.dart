// lib/features/patient/controllers/patient_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/ambulance_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/hospital_model.dart';
import '../../../data/models/user_model.dart';
import '../../auth/controllers/auth_controller.dart';

class PatientController extends GetxController {
  int currentTabIndex = 0;

  // Hospitals & Ambulances
  List<HospitalModel> hospitals = List.from(DummyData.hospitals);
  List<AmbulanceModel> ambulances = List.from(DummyData.publicAmbulances);

  // Bookings
  List<BookingModel> bookings = List.from(DummyData.patientBookings);

  // Filters
  bool filterNearbyHospital = false;
  bool filterNearbyAmbulance = false;
  bool filterNicuOnly = false;

  // Profile
  late UserModel profileData;

  @override
  void onInit() {
    super.onInit();
    profileData = Get.find<AuthController>().currentUser!;
  }

  // ─── Navigation ───────────────────────────────────────────────────────────

  void changeTab(int index) {
    currentTabIndex = index;
    update();
  }

  // ─── Hospital Filters ─────────────────────────────────────────────────────

  void toggleNearbyHospital() {
    filterNearbyHospital = !filterNearbyHospital;
    update();
  }

  List<HospitalModel> get filteredHospitals {
    var list = hospitals.where((h) => h.hasAvailableBeds).toList();
    if (filterNearbyHospital) {
      list = list.where((h) => (h.distanceKm ?? 99) <= 5.0).toList();
    }
    return list;
  }

  // ─── Ambulance Filters ────────────────────────────────────────────────────

  void toggleNearbyAmbulance() {
    filterNearbyAmbulance = !filterNearbyAmbulance;
    update();
  }

  void toggleNicuOnly() {
    filterNicuOnly = !filterNicuOnly;
    update();
  }

  List<AmbulanceModel> get filteredAmbulances {
    var list =
        ambulances.where((a) => a.status == AmbulanceStatus.active).toList();
    if (filterNicuOnly) {
      list = list.where((a) => a.hasNicuFacility).toList();
    }
    // Nearby = service areas contain "Dhaka" as a proxy
    if (filterNearbyAmbulance) {
      list = list.where((a) => a.serviceAreas.contains('Dhaka')).toList();
    }
    return list;
  }

  // ─── Book NICU Bed ────────────────────────────────────────────────────────

  void bookNicuBed(HospitalModel hospital) {
    final booking = BookingModel(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      patientName: profileData.name,
      phone: profileData.phone ?? '',
      type: BookingType.nicuBed,
      status: BookingStatus.pending,
      targetName: hospital.name,
      date: DateTime.now(),
    );
    bookings.insert(0, booking);
    update();
    Get.back();
    Get.snackbar(
      AppStrings.bookingSuccess,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─── Book Ambulance ───────────────────────────────────────────────────────

  void bookAmbulance(AmbulanceModel ambulance) {
    final booking = BookingModel(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      patientName: profileData.name,
      phone: profileData.phone ?? '',
      type: BookingType.ambulance,
      status: BookingStatus.pending,
      targetName: ambulance.agencyName ?? ambulance.vehicleName,
      date: DateTime.now(),
    );
    bookings.insert(0, booking);
    update();
    Get.back();
    Get.snackbar(
      AppStrings.bookingSuccess,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─── Profile ──────────────────────────────────────────────────────────────

  void updateProfile(
      {required String name,
      required String phone,
      required String address}) {
    profileData =
        profileData.copyWith(name: name, phone: phone, address: address);
    update();
    Get.snackbar(
      AppStrings.profileSaved,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }
}
