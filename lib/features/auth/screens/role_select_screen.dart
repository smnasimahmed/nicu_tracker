// lib/features/auth/screens/role_select_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/connectivity_wrapper.dart';
import '../controllers/auth_controller.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo area
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.hospitalPrimary,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusXL),
                    ),
                    child: const Icon(
                      Icons.local_hospital_rounded,
                      color: AppColors.textWhite,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                  const Text(AppStrings.appName, style: AppTextStyles.heading1),
                  const SizedBox(height: AppDimensions.paddingS),
                  const Text(
                    'NICU Management System',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppDimensions.paddingXXL + 8),
                  const Text(
                    AppStrings.selectRole,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                  _RoleCard(
                    title: AppStrings.loginAsHospital,
                    subtitle: 'Dashboard, NICU beds & patient referrals',
                    icon: Icons.local_hospital_rounded,
                    color: AppColors.hospitalPrimary,
                    onTap: () => Get.find<AuthController>()
                        .selectRole(UserRole.hospital),
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),
                  _RoleCard(
                    title: AppStrings.loginAsAmbulance,
                    subtitle: 'Manage your fleet & service availability',
                    icon: Icons.airport_shuttle_rounded,
                    color: AppColors.ambulancePrimary,
                    onTap: () => Get.find<AuthController>()
                        .selectRole(UserRole.ambulance),
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),
                  _RoleCard(
                    title: AppStrings.loginAsPatient,
                    subtitle: 'Book NICU beds & ambulance services',
                    icon: Icons.person_rounded,
                    color: AppColors.patientPrimary,
                    onTap: () => Get.find<AuthController>()
                        .selectRole(UserRole.patient),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(icon, color: color, size: AppDimensions.iconXL),
              ),
              const SizedBox(width: AppDimensions.paddingBase),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.heading3),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: AppDimensions.iconS, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
