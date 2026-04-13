// lib/features/ambulance/screens/ambulance_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/ambulance_model.dart';
import '../controllers/ambulance_controller.dart';

class AmbulanceDashboardScreen extends StatelessWidget {
  const AmbulanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AmbulanceController>(
      builder: (controller) {
        return ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          children: [
            // Stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: AppStrings.totalRegistered,
                    value: controller.totalRegistered.toString(),
                    sublabel: AppStrings.ambulancesInFleet,
                    icon: Icons.airport_shuttle_rounded,
                    iconColor: AppColors.ambulancePrimary,
                    borderColor: AppColors.ambulancePrimary,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: _StatCard(
                    label: AppStrings.activeAmbulances,
                    value: controller.activeCount.toString(),
                    sublabel: AppStrings.currentlyOnDuty,
                    icon: Icons.favorite_rounded,
                    iconColor: AppColors.statusAvailable,
                    borderColor: AppColors.statusAvailable,
                    valueColor: AppColors.statusAvailable,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: _StatCard(
                    label: AppStrings.inactiveMaintenance,
                    value: controller.inactiveCount.toString(),
                    sublabel: AppStrings.currentlyOffline,
                    icon: Icons.warning_amber_rounded,
                    iconColor: AppColors.warning,
                    borderColor: AppColors.warning,
                    valueColor: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // Quick status overview
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingBase),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppStrings.quickStatusOverview,
                      style: AppTextStyles.heading3),
                  const SizedBox(height: AppDimensions.paddingM),
                  ...controller.ambulances.map((amb) => _AmbulanceListItem(
                        ambulance: amb,
                        onToggle: () => controller.toggleStatus(amb.id),
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sublabel;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color? valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sublabel,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: AppTextStyles.bodySmall,
                    overflow: TextOverflow.ellipsis),
              ),
              Icon(icon, color: iconColor, size: AppDimensions.iconM),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(value,
              style: AppTextStyles.statNumber
                  .copyWith(color: valueColor, fontSize: 28)),
          Text(sublabel,
              style: AppTextStyles.statLabel,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _AmbulanceListItem extends StatelessWidget {
  final AmbulanceModel ambulance;
  final VoidCallback onToggle;

  const _AmbulanceListItem(
      {required this.ambulance, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isActive = ambulance.status == AmbulanceStatus.active;
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.statusAvailableBg
                      : AppColors.statusCancelledBg,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  Icons.airport_shuttle_rounded,
                  color: isActive
                      ? AppColors.statusAvailable
                      : AppColors.statusCancelled,
                  size: AppDimensions.iconM,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ambulance.vehicleName,
                        style: AppTextStyles.labelLarge),
                    Text(ambulance.registrationNumber,
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              AmbulanceStatusBadge(status: ambulance.status),
              const SizedBox(width: AppDimensions.paddingS),
              Switch.adaptive(
                value: isActive,
                onChanged: (_) => onToggle(),
                activeColor: AppColors.statusAvailable,
              ),
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
