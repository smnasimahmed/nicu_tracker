// lib/features/ambulance/screens/ambulance_main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/connectivity_wrapper.dart';
import '../controllers/ambulance_controller.dart';
import 'ambulance_dashboard_screen.dart';
import 'ambulance_fleet_screen.dart';
import 'ambulance_profile_screen.dart';

class AmbulanceMainScreen extends StatelessWidget {
  const AmbulanceMainScreen({super.key});

  String _appBarTitle(int index) {
    switch (index) {
      case 0: return AppStrings.dashboard;
      case 1: return AppStrings.myFleet;
      case 2: return AppStrings.myProfile;
      default: return AppStrings.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: GetBuilder<AmbulanceController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              title: Text(_appBarTitle(controller.currentTabIndex),
                  style: AppTextStyles.heading3),
              actions: controller.currentTabIndex == 1
                  ? [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: AppDimensions.paddingBase),
                        child: SizedBox(
                          width: 110,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                AmbulanceFleetScreen.showAddForm(context, controller),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add New',
                                style: TextStyle(fontSize: AppDimensions.fontS)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.ambulancePrimary,
                              foregroundColor: AppColors.textWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusM)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingM,
                                  vertical: 8),
                            ),
                          ),
                        ),
                      ),
                    ]
                  : null,
            ),
            body: _buildBody(controller.currentTabIndex),
            bottomNavigationBar: _AmbulanceBottomNav(controller: controller),
          );
        },
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0: return const AmbulanceDashboardScreen();
      case 1: return const AmbulanceFleetScreen();
      case 2: return const AmbulanceProfileScreen();
      default: return const AmbulanceDashboardScreen();
    }
  }
}

class _AmbulanceBottomNav extends StatelessWidget {
  final AmbulanceController controller;
  const _AmbulanceBottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: AppStrings.dashboard,
                selected: controller.currentTabIndex == 0,
                color: AppColors.ambulancePrimary,
                onTap: () => controller.changeTab(0),
              ),
              _NavItem(
                icon: Icons.airport_shuttle_rounded,
                label: AppStrings.myFleet,
                selected: controller.currentTabIndex == 1,
                color: AppColors.ambulancePrimary,
                onTap: () => controller.changeTab(1),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: AppStrings.myProfile,
                selected: controller.currentTabIndex == 2,
                color: AppColors.ambulancePrimary,
                onTap: () => controller.changeTab(2),
              ),
            ],
          ),
        ),
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
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: selected
                      ? color.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Icon(icon,
                    color: selected ? color : AppColors.textSecondary,
                    size: 22),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: selected ? color : AppColors.textSecondary,
                  fontSize: AppDimensions.fontXS,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
