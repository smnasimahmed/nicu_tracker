// lib/features/hospital/screens/hospital_refer_history_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicu_tracker/core/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/referral_model.dart';
import '../controllers/hospital_controller.dart';

class HospitalReferHistoryScreen extends StatelessWidget {
  const HospitalReferHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HospitalController>(
      builder: (controller) {
        if (controller.outgoingReferrals.isEmpty) {
          return const Center(
            child: Text(
              AppStrings.noReferralHistory,
              style: AppTextStyles.bodyMedium,
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          itemCount: controller.outgoingReferrals.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppDimensions.paddingM),
          itemBuilder: (_, i) => _ReferralCard(
            referral: controller.outgoingReferrals[i],
            controller: controller,
          ),
        );
      },
    );
  }
}

class _ReferralCard extends StatelessWidget {
  final ReferralModel referral;
  final HospitalController controller;

  const _ReferralCard({required this.referral, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isCancellable = referral.status == ReferralStatus.pending;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingBase),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row — baby name + status badge
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(referral.babyName, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    Text(
                      'Guardian: ${referral.guardianContact}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              ReferralStatusBadge(status: referral.status),
            ],
          ),
          const Divider(height: AppDimensions.paddingXL),

          // Route: From → To
          Row(
            children: [
              const Icon(
                Icons.local_hospital_outlined,
                size: AppDimensions.iconS,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: Text(
                  referral.fromHospital,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: AppDimensions.iconS,
                  color: AppColors.textSecondary,
                ),
              ),
              Expanded(
                child: Text(
                  referral.toHospital,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: AppDimensions.iconS,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimensions.paddingS),
              Text(_formatDate(referral.date), style: AppTextStyles.bodySmall),
            ],
          ),

          // Cancel button — only for pending referrals
          if (isCancellable) ...[
            const SizedBox(height: AppDimensions.paddingBase),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCancelDialog(context),
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: AppDimensions.iconS,
                ),
                label: const Text(AppStrings.cancelReferral),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  minimumSize: const Size(0, 38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  textStyle: const TextStyle(
                    fontSize: AppDimensions.fontS,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: const Text('Cancel Referral', style: AppTextStyles.heading3),
        content: Text(
          'Cancel referral for ${referral.babyName} to ${referral.toHospital}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: AppStrings.yes,
                  style: AppButtonStyle.danger,
                  onPressed: () {
                    Get.back();
                    controller.cancelOutgoingReferral(referral.id);
                  },
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: AppButton(
                  label: AppStrings.no,
                  style: AppButtonStyle.outline,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
