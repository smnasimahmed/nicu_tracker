// lib/features/hospital/screens/hospital_incoming_referrals_screen.dart
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

class HospitalIncomingReferralsScreen extends StatelessWidget {
  const HospitalIncomingReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HospitalController>(
      builder: (controller) {
        if (controller.incomingReferrals.isEmpty) {
          return const Center(
            child: Text(
              AppStrings.noIncomingReferrals,
              style: AppTextStyles.bodyMedium,
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          itemCount: controller.incomingReferrals.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppDimensions.paddingM),
          itemBuilder: (_, i) => _IncomingReferralCard(
            referral: controller.incomingReferrals[i],
            controller: controller,
          ),
        );
      },
    );
  }
}

class _IncomingReferralCard extends StatelessWidget {
  final ReferralModel referral;
  final HospitalController controller;

  const _IncomingReferralCard({
    required this.referral,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(referral.babyName, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    Text(
                      'From: ${referral.fromHospital}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              ReferralStatusBadge(status: referral.status),
            ],
          ),
          const Divider(height: AppDimensions.paddingXL),

          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: 'Guardian',
            value: referral.guardianContact,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          if (referral.reasonForTransfer?.isNotEmpty == true)
            _DetailRow(
              icon: Icons.info_outline_rounded,
              label: 'Reason',
              value: referral.reasonForTransfer!,
            ),
          const SizedBox(height: AppDimensions.paddingS),
          _DetailRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: _formatDate(referral.date),
          ),

          if (referral.status != ReferralStatus.completed &&
              referral.status != ReferralStatus.cancelled) ...[
            const SizedBox(height: AppDimensions.paddingBase),
            Row(
              children: [
                if (referral.status == ReferralStatus.pending) ...[
                  Expanded(
                    child: _ActionButton(
                      label: AppStrings.confirmReferral,
                      color: AppColors.statusConfirm,
                      onPressed: () => controller.updateIncomingReferralStatus(
                        referral.id,
                        ReferralStatus.confirmed,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                ],
                if (referral.status == ReferralStatus.confirmed)
                  Expanded(
                    child: _ActionButton(
                      label: AppStrings.completeReferral,
                      color: AppColors.statusCompleted,
                      onPressed: () => controller.updateIncomingReferralStatus(
                        referral.id,
                        ReferralStatus.completed,
                      ),
                    ),
                  ),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: _ActionButton(
                    label: AppStrings.cancelReferral,
                    color: AppColors.statusCancelled,
                    onPressed: () => _showCancelDialog(context),
                  ),
                ),
              ],
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
        content: const Text(
          'Are you sure you want to cancel this referral?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: AppStrings.no,
                  style: AppButtonStyle.danger,
                  onPressed: () {
                    Get.back();
                    controller.updateIncomingReferralStatus(
                      referral.id,
                      ReferralStatus.cancelled,
                    );
                  },
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: AppButton(
                  label: AppStrings.yes,
                  style: AppButtonStyle.primary,
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppDimensions.iconS, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.paddingS),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.textWhite,
        minimumSize: const Size(0, 38),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: AppDimensions.fontS,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
