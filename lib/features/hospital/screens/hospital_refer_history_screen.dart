// lib/features/hospital/screens/hospital_refer_history_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/referral_model.dart';
import '../controllers/hospital_controller.dart';

class HospitalReferHistoryScreen extends StatefulWidget {
  const HospitalReferHistoryScreen({super.key});

  @override
  State<HospitalReferHistoryScreen> createState() =>
      _HospitalReferHistoryScreenState();
}

class _HospitalReferHistoryScreenState
    extends State<HospitalReferHistoryScreen> {
  bool _showIncoming = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HospitalController>(
      builder: (controller) {
        final referrals =
            _showIncoming ? controller.incomingReferrals : controller.outgoingReferrals;

        return Column(
          children: [
            // ── Top Tab Switcher ──────────────────────────────────────
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingBase,
                AppDimensions.paddingS,
                AppDimensions.paddingBase,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _TabButton(
                      label: AppStrings.incomingReferrals,
                      selected: _showIncoming,
                      onTap: () => setState(() => _showIncoming = true),
                    ),
                  ),
                  Expanded(
                    child: _TabButton(
                      label: AppStrings.outgoingReferrals,
                      selected: !_showIncoming,
                      onTap: () => setState(() => _showIncoming = false),
                    ),
                  ),
                ],
              ),
            ),

            // ── List ──────────────────────────────────────────────────
            Expanded(
              child: referrals.isEmpty
                  ? Center(
                      child: Text(
                        _showIncoming
                            ? AppStrings.noIncomingReferrals
                            : AppStrings.noReferralHistory,
                        style: AppTextStyles.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppDimensions.paddingBase),
                      itemCount: referrals.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppDimensions.paddingM),
                      itemBuilder: (_, i) => _showIncoming
                          ? _IncomingReferralCard(
                              referral: referrals[i],
                              controller: controller,
                            )
                          : _OutgoingReferralCard(
                              referral: referrals[i],
                              controller: controller,
                            ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Tab Button ────────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.hospitalPrimary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppDimensions.fontM,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? AppColors.hospitalPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Incoming Referral Card ────────────────────────────────────────────────

class _IncomingReferralCard extends StatelessWidget {
  final ReferralModel referral;
  final HospitalController controller;

  const _IncomingReferralCard({
    required this.referral,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = referral.status == ReferralStatus.pending;

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
          // Header
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
          if (referral.reasonForTransfer?.isNotEmpty == true) ...[
            _DetailRow(
              icon: Icons.info_outline_rounded,
              label: 'Reason',
              value: referral.reasonForTransfer!,
            ),
            const SizedBox(height: AppDimensions.paddingS),
          ],
          _DetailRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: _formatDate(referral.date),
          ),

          // Actions: pending -> Approve + Reject
          if (isPending) ...[
            const SizedBox(height: AppDimensions.paddingBase),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.updateIncomingReferralStatus(
                      referral.id,
                      ReferralStatus.confirmed,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusAvailable,
                      foregroundColor: AppColors.textWhite,
                      minimumSize: const Size(0, 38),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                    child: const Text(
                      AppStrings.approve,
                      style: TextStyle(
                        fontSize: AppDimensions.fontS,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showRejectDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusOccupied,
                      foregroundColor: AppColors.textWhite,
                      minimumSize: const Size(0, 38),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                    child: const Text(
                      AppStrings.reject,
                      style: TextStyle(
                        fontSize: AppDimensions.fontS,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: const Text('Reject Referral', style: AppTextStyles.heading3),
        content: Text(
          'Reject referral for ${referral.babyName} from ${referral.fromHospital}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: AppStrings.reject,
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
                  label: AppStrings.cancel,
                  style: AppButtonStyle.outline,
                  onPressed: Get.back,
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

// ─── Outgoing Referral Card ────────────────────────────────────────────────

class _OutgoingReferralCard extends StatelessWidget {
  final ReferralModel referral;
  final HospitalController controller;

  const _OutgoingReferralCard({
    required this.referral,
    required this.controller,
  });

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
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(referral.babyName, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    Text(
                      'To: ${referral.toHospital}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              ReferralStatusBadge(status: referral.status),
            ],
          ),
          const Divider(height: AppDimensions.paddingXL),

          // Route
          Row(
            children: [
              const Icon(Icons.local_hospital_outlined,
                  size: AppDimensions.iconS, color: AppColors.textSecondary),
              const SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: Text(
                  referral.fromHospital,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
                child: Icon(Icons.arrow_forward_rounded,
                    size: AppDimensions.iconS, color: AppColors.textSecondary),
              ),
              Expanded(
                child: Text(
                  referral.toHospital,
                  style:
                      AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),

          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: 'Guardian',
            value: referral.guardianContact,
          ),
          const SizedBox(height: AppDimensions.paddingS),

          _DetailRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: _formatDate(referral.date),
          ),

          // Cancel button — only for pending
          if (isCancellable) ...[
            const SizedBox(height: AppDimensions.paddingBase),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCancelDialog(context),
                icon: const Icon(Icons.cancel_outlined,
                    size: AppDimensions.iconS),
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
                  onPressed: Get.back,
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

// ─── Detail Row ────────────────────────────────────────────────────────────

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