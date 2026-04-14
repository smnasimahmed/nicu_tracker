// lib/features/hospital/controllers/hospital_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/nicu_bed_model.dart';
import '../../../data/models/referral_model.dart';

class HospitalController extends GetxController {
  int currentTabIndex = 0;

  // NICU Beds
  List<NicuBedModel> beds = List.from(DummyData.nicuBeds);

  // Referrals
  List<ReferralModel> outgoingReferrals = List.from(DummyData.outgoingReferrals);
  List<ReferralModel> incomingReferrals = List.from(DummyData.incomingReferrals);

  // Derived stats
  int get totalBeds => beds.length;
  int get availableBeds =>
      beds.where((b) => b.status == BedStatus.available).length;
  int get occupiedBeds =>
      beds.where((b) => b.status == BedStatus.occupied).length;
  int get incomingReferralCount =>
      incomingReferrals.where((r) => r.status == ReferralStatus.pending).length;

  void changeTab(int index) {
    currentTabIndex = index;
    update();
  }

  // ─── Admit Patient ────────────────────────────────────────────────────────

  void admitPatient({
    required String bedId,
    required String? babyName,
    required String guardianName,
    required String guardianRelation,
    required String guardianPhone,
  }) {
    final idx = beds.indexWhere((b) => b.id == bedId);
    if (idx == -1) return;
    beds[idx] = beds[idx].copyWith(
      status: BedStatus.occupied,
      babyName: babyName?.isEmpty == true ? null : babyName,
      guardianName: guardianName,
      guardianRelation: guardianRelation,
      guardianPhone: guardianPhone,
      admittedDate: DateTime.now(),
    );
    update();
    Get.back(); // close dialog
    Get.snackbar(
      AppStrings.bedAdmitSuccess,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─── Discharge Patient ────────────────────────────────────────────────────

  void dischargePatient(String bedId) {
    final idx = beds.indexWhere((b) => b.id == bedId);
    if (idx == -1) return;
    beds[idx] = NicuBedModel(
      id: beds[idx].id,
      bedCode: beds[idx].bedCode,
      status: BedStatus.available,
    );
    update();
    Get.snackbar(
      AppStrings.bedDischargeSuccess,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─── Send Referral ────────────────────────────────────────────────────────

  void sendReferral({
    required String? babyName,
    required String guardianContact,
    required String? reasonForTransfer,
    required String toHospital,
  }) {
    final newReferral = ReferralModel(
      id: 'ref_${DateTime.now().millisecondsSinceEpoch}',
      babyName: babyName?.isNotEmpty == true ? babyName! : 'Unknown Baby',
      fromHospital: 'Dhaka Medical College Hospital',
      toHospital: toHospital,
      guardianContact: guardianContact,
      reasonForTransfer: reasonForTransfer,
      date: DateTime.now(),
      status: ReferralStatus.pending,
      isIncoming: false,
    );
    outgoingReferrals.insert(0, newReferral);
    update();
    Get.snackbar(
      AppStrings.referralSentSuccess,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─── Cancel Outgoing Referral ─────────────────────────────────────────────

  void cancelOutgoingReferral(String referralId) {
    final idx = outgoingReferrals.indexWhere((r) => r.id == referralId);
    if (idx == -1) return;
    outgoingReferrals[idx] =
        outgoingReferrals[idx].copyWith(status: ReferralStatus.cancelled);
    update();
    Get.snackbar(
      'Referral cancelled',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─── Update Incoming Referral Status ──────────────────────────────────────

  void updateIncomingReferralStatus(String referralId, ReferralStatus status) {
    final idx = incomingReferrals.indexWhere((r) => r.id == referralId);
    if (idx == -1) return;
    incomingReferrals[idx] = incomingReferrals[idx].copyWith(status: status);
    update();
    Get.snackbar(
      'Status updated successfully',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }
}
