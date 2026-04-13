// lib/core/widgets/status_badge.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../constants/app_enums.dart';

class BedStatusBadge extends StatelessWidget {
  final BedStatus status;

  const BedStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _config;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: config.dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: TextStyle(
              color: config.dot,
              fontSize: AppDimensions.fontS,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig get _config {
    switch (status) {
      case BedStatus.occupied:
        return _BadgeConfig(
          label: AppStrings.statusOccupied,
          dot: AppColors.statusOccupied,
          bg: AppColors.statusOccupiedBg,
        );
      case BedStatus.available:
        return _BadgeConfig(
          label: AppStrings.statusAvailable,
          dot: AppColors.statusAvailable,
          bg: AppColors.statusAvailableBg,
        );
      case BedStatus.inTransit:
        return _BadgeConfig(
          label: AppStrings.statusInTransit,
          dot: AppColors.statusInTransit,
          bg: AppColors.statusInTransitBg,
        );
    }
  }
}

class ReferralStatusBadge extends StatelessWidget {
  final ReferralStatus status;

  const ReferralStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _config;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingXS + 2,
      ),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.dot,
          fontSize: AppDimensions.fontS,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _BadgeConfig get _config {
    switch (status) {
      case ReferralStatus.pending:
        return _BadgeConfig(
          label: AppStrings.pending,
          dot: AppColors.statusPending,
          bg: AppColors.statusPendingBg,
        );
      case ReferralStatus.confirmed:
        return _BadgeConfig(
          label: AppStrings.confirm,
          dot: AppColors.statusConfirm,
          bg: AppColors.statusConfirmBg,
        );
      case ReferralStatus.completed:
        return _BadgeConfig(
          label: AppStrings.completed,
          dot: AppColors.statusCompleted,
          bg: AppColors.statusCompletedBg,
        );
      case ReferralStatus.cancelled:
        return _BadgeConfig(
          label: AppStrings.cancelled,
          dot: AppColors.statusCancelled,
          bg: AppColors.statusCancelledBg,
        );
    }
  }
}

class AmbulanceStatusBadge extends StatelessWidget {
  final AmbulanceStatus status;

  const AmbulanceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == AmbulanceStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS + 1,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.statusAvailable : AppColors.statusCancelled,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        isActive ? AppStrings.active : AppStrings.inactive,
        style: const TextStyle(
          color: AppColors.textWhite,
          fontSize: AppDimensions.fontS,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BadgeConfig {
  final String label;
  final Color dot;
  final Color bg;
  const _BadgeConfig({required this.label, required this.dot, required this.bg});
}
