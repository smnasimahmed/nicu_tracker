// lib/features/patient/screens/patient_main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/connectivity_wrapper.dart';
import '../controllers/patient_controller.dart';
import 'patient_book_nicu_screen.dart';
import 'patient_book_ambulance_screen.dart';
import 'patient_bookings_screen.dart';
import 'patient_profile_screen.dart';

class PatientMainScreen extends StatelessWidget {
  const PatientMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: GetBuilder<PatientController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: _buildBody(controller.currentTabIndex),
            bottomNavigationBar: _PatientBottomNav(controller: controller),
          );
        },
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const PatientBookNicuScreen();
      case 1:
        return const PatientBookAmbulanceScreen();
      case 2:
        return const PatientBookingsScreen();
      case 3:
        return const PatientProfileScreen();
      default:
        return const PatientBookNicuScreen();
    }
  }
}

class _PatientBottomNav extends StatelessWidget {
  final PatientController controller;
  const _PatientBottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _NavItem(
            icon: Icons.bed_rounded,
            label: AppStrings.bookNicuBed,
            selected: controller.currentTabIndex == 0,
            color: AppColors.patientPrimary,
            onTap: () => controller.changeTab(0),
          ),
          _NavItem(
            icon: Icons.airport_shuttle_rounded,
            label: AppStrings.bookAmbulance,
            selected: controller.currentTabIndex == 1,
            color: AppColors.patientPrimary,
            onTap: () => controller.changeTab(1),
          ),
          _NavItem(
            icon: Icons.history_rounded,
            label: AppStrings.myBookings,
            selected: controller.currentTabIndex == 2,
            color: AppColors.patientPrimary,
            onTap: () => controller.changeTab(2),
          ),
          _NavItem(
            icon: Icons.person_rounded,
            label: AppStrings.profile,
            selected: controller.currentTabIndex == 3,
            color: AppColors.patientPrimary,
            onTap: () => controller.changeTab(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? color : AppColors.textSecondary,
              size: AppDimensions.iconL,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : AppColors.textSecondary,
                fontSize: 9,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
