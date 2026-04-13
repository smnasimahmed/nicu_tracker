// lib/features/hospital/screens/hospital_refer_history_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
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
            child: Text(AppStrings.noReferralHistory,
                style: AppTextStyles.bodyMedium),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const _TableHeader(),
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              ...controller.outgoingReferrals.map((r) => _ReferralRow(referral: r)),
            ],
          ),
        );
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingBase,
          vertical: AppDimensions.paddingM),
      child: Row(
        children: [
          _HeaderCell(AppStrings.baby, flex: 2),
          _HeaderCell(AppStrings.from, flex: 3),
          _HeaderCell(AppStrings.to, flex: 3),
          _HeaderCell(AppStrings.guardianLabel, flex: 2),
          _HeaderCell(AppStrings.date, flex: 2),
          _HeaderCell(AppStrings.status, flex: 2),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(text,
          style: AppTextStyles.labelMedium
              .copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _ReferralRow extends StatelessWidget {
  final ReferralModel referral;
  const _ReferralRow({required this.referral});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingXS),
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingBase,
          vertical: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(flex: 2,
              child: Text(referral.babyName, style: AppTextStyles.bodyMedium)),
          Expanded(flex: 3,
              child: Text(referral.fromHospital,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis)),
          Expanded(flex: 3,
              child: Text(referral.toHospital,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2,
              child: Text(referral.guardianContact,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2,
              child: Text(_formatDate(referral.date),
                  style: AppTextStyles.bodySmall)),
          Expanded(flex: 2,
              child: ReferralStatusBadge(status: referral.status)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
