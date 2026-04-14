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
            // ── Stats — stacked vertically so text is fully visible ──────
            _StatCard(
              label: AppStrings.totalRegistered,
              sublabel: AppStrings.ambulancesInFleet,
              value: controller.totalRegistered.toString(),
              icon: Icons.airport_shuttle_rounded,
              iconColor: AppColors.ambulancePrimary,
              accentColor: AppColors.ambulancePrimary,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _StatCard(
              label: AppStrings.activeAmbulances,
              sublabel: AppStrings.currentlyOnDuty,
              value: controller.activeCount.toString(),
              icon: Icons.check_circle_rounded,
              iconColor: AppColors.statusAvailable,
              accentColor: AppColors.statusAvailable,
              valueColor: AppColors.statusAvailable,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _StatCard(
              label: AppStrings.inactiveMaintenance,
              sublabel: AppStrings.currentlyOffline,
              value: controller.inactiveCount.toString(),
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.warning,
              accentColor: AppColors.warning,
              valueColor: AppColors.warning,
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // ── Quick status overview ──────────────────────────────────
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
                  if (controller.ambulances.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingXL),
                      child: Center(
                        child: Text('No ambulances registered yet.',
                            style: AppTextStyles.bodySmall),
                      ),
                    )
                  else
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
  final String sublabel;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color accentColor;
  final Color? valueColor;

  const _StatCard({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.accentColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingBase),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
        // Accent left bar instead of squishing content 3-wide
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Accent icon box
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, color: iconColor, size: AppDimensions.iconL),
          ),
          const SizedBox(width: AppDimensions.paddingBase),
          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(sublabel,
                    style: AppTextStyles.bodySmall,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // Big number — never squished
          Text(
            value,
            style: AppTextStyles.statNumber.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontSize: 32,
            ),
          ),
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
