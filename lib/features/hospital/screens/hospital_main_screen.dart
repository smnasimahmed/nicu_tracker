// lib/features/hospital/screens/hospital_main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/connectivity_wrapper.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/hospital_controller.dart';
import 'hospital_dashboard_screen.dart';
import 'hospital_nicu_beds_screen.dart';
import 'hospital_refer_patient_screen.dart';
import 'hospital_refer_history_screen.dart';
import 'hospital_incoming_referrals_screen.dart';

class HospitalMainScreen extends StatelessWidget {
  const HospitalMainScreen({super.key});

  String _appBarTitle(int index) {
    switch (index) {
      case 0: return AppStrings.dashboard;
      case 1: return AppStrings.nicuBedsManagement;
      case 2: return AppStrings.referPatient;
      case 3: return AppStrings.referralHistory;
      case 4: return AppStrings.incomingReferrals;
      default: return AppStrings.dashboard;
    }
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0: return const HospitalDashboardScreen();
      case 1: return const HospitalNicuBedsScreen();
      case 2: return const HospitalReferPatientScreen();
      case 3: return const HospitalReferHistoryScreen();
      case 4: return const HospitalIncomingReferralsScreen();
      default: return const HospitalDashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: GetBuilder<HospitalController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              scrolledUnderElevation: 1,
              title: Text(_appBarTitle(controller.currentTabIndex),
                  style: AppTextStyles.heading3),
              actions: [
                _LogoutButton(),
              ],
            ),
            body: _buildBody(controller.currentTabIndex),
            bottomNavigationBar: _HospitalBottomNav(controller: controller),
          );
        },
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.paddingBase),
      child: Row(
        children: [
          Text(
            authCtrl.currentUser?.name ?? '',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(width: AppDimensions.paddingS),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.hospitalPrimary,
            child: Text(
              authCtrl.currentUser?.name.isNotEmpty == true
                  ? authCtrl.currentUser!.name.substring(0, 2).toUpperCase()
                  : 'DR',
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          IconButton(
            icon: const Icon(Icons.logout_rounded,
                color: AppColors.textSecondary, size: AppDimensions.iconM),
            tooltip: AppStrings.logout,
            onPressed: () => authCtrl.logout(),
          ),
        ],
      ),
    );
  }
}

class _HospitalBottomNav extends StatelessWidget {
  final HospitalController controller;
  const _HospitalBottomNav({required this.controller});

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
            icon: Icons.dashboard_rounded,
            label: AppStrings.dashboard,
            selected: controller.currentTabIndex == 0,
            onTap: () => controller.changeTab(0),
          ),
          _NavItem(
            icon: Icons.bed_rounded,
            label: AppStrings.nicuBeds,
            selected: controller.currentTabIndex == 1,
            onTap: () => controller.changeTab(1),
          ),
          _NavItem(
            icon: Icons.send_rounded,
            label: AppStrings.referPatient,
            selected: controller.currentTabIndex == 2,
            onTap: () => controller.changeTab(2),
          ),
          _NavItem(
            icon: Icons.history_rounded,
            label: AppStrings.referHistory,
            selected: controller.currentTabIndex == 3,
            onTap: () => controller.changeTab(3),
          ),
          _NavItem(
            icon: Icons.inbox_rounded,
            label: AppStrings.incomingReferrals,
            selected: controller.currentTabIndex == 4,
            onTap: () => controller.changeTab(4),
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
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
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
              color: selected ? AppColors.hospitalPrimary : AppColors.textSecondary,
              size: AppDimensions.iconL,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.hospitalPrimary : AppColors.textSecondary,
                fontSize: 9,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
