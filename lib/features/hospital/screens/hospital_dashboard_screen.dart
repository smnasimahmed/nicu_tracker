// lib/features/hospital/screens/hospital_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/nicu_bed_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/hospital_controller.dart';

class HospitalDashboardScreen extends StatelessWidget {
  const HospitalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    return GetBuilder<HospitalController>(
      builder: (controller) {
        return ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          children: [
            Text(
              authCtrl.currentUser?.organizationName ?? AppStrings.appName,
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppDimensions.paddingBase),

            // ── 3 Stat Cards in a single row ───────────────────────────
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: AppStrings.totalBeds,
                    value: controller.totalBeds.toString(),
                    icon: Icons.bed_rounded,
                    iconColor: AppColors.hospitalPrimary,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: _StatCard(
                    label: AppStrings.availableBeds,
                    value: controller.availableBeds.toString(),
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: AppColors.statusAvailable,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: _StatCard(
                    label: AppStrings.occupiedBeds,
                    value: controller.occupiedBeds.toString(),
                    icon: Icons.error_outline_rounded,
                    iconColor: AppColors.statusOccupied,
                  ),
                ),
              ],
            ),

            // ── Referrals row ──────────────────────────────────────────
            const SizedBox(height: AppDimensions.paddingXL),
            const Text(AppStrings.referrals, style: AppTextStyles.heading3),
            const SizedBox(height: AppDimensions.paddingM),
            Row(
              children: [
                Expanded(
                  child: _ReferralStatCard(
                    label: AppStrings.incomingReferrals,
                    value: controller.incomingReferralCount.toString(),
                    icon: Icons.south_west_rounded,
                    accentColor: AppColors.hospitalPrimary,
                    onTap: () => controller.changeTab(3),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: _ReferralStatCard(
                    label: AppStrings.outgoingReferrals,
                    value: controller.outgoingReferralCount.toString(),
                    icon: Icons.north_east_rounded,
                    accentColor: const Color(0xFFF59E0B),
                    onTap: () => controller.changeTab(3),
                  ),
                ),
              ],
            ),

            // ── Bed Tracking ───────────────────────────────────────────
            const SizedBox(height: AppDimensions.paddingXL),
            const Text(AppStrings.bedTracking, style: AppTextStyles.heading3),
            const SizedBox(height: AppDimensions.paddingM),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: AppDimensions.paddingM,
                mainAxisSpacing: AppDimensions.paddingM,
                childAspectRatio: 1.2,
              ),
              itemCount: controller.beds.length,
              itemBuilder: (_, i) => _DashboardBedCard(bed: controller.beds[i]),
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
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: AppDimensions.iconL),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.statLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: AppTextStyles.statNumber.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferralStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  const _ReferralStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingBase),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Icon(icon, color: accentColor, size: 24),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.statLabel),
                  Text(
                    value,
                    style: AppTextStyles.statNumber.copyWith(fontSize: 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBedCard extends StatelessWidget {
  final NicuBedModel bed;
  const _DashboardBedCard({required this.bed});

  @override
  Widget build(BuildContext context) {
    final isAvailable = bed.status == BedStatus.available;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(bed.bedCode, style: AppTextStyles.cardTitle),
          const SizedBox(height: AppDimensions.paddingS),
          if (isAvailable)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.statusAvailableBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: const Icon(
                Icons.qr_code_rounded,
                color: AppColors.statusAvailable,
                size: 28,
              ),
            ),
          const SizedBox(height: AppDimensions.paddingXS),
          _statusChip(bed.status),
        ],
      ),
    );
  }

  Widget _statusChip(BedStatus status) {
    final Color dot;
    final Color bg;
    final String label;
    switch (status) {
      case BedStatus.available:
        dot = AppColors.statusAvailable;
        bg = AppColors.statusAvailableBg;
        label = AppStrings.statusAvailable;
        break;
      case BedStatus.occupied:
        dot = AppColors.statusOccupied;
        bg = AppColors.statusOccupiedBg;
        label = AppStrings.statusOccupied;
        break;
      case BedStatus.inTransit:
        dot = AppColors.statusInTransit;
        bg = AppColors.statusInTransitBg;
        label = AppStrings.statusInTransit;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: dot,
              fontSize: AppDimensions.fontXS,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
