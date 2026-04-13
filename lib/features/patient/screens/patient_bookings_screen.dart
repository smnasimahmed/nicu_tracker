// lib/features/patient/screens/patient_bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/booking_model.dart';
import '../controllers/patient_controller.dart';

class PatientBookingsScreen extends StatelessWidget {
  const PatientBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientController>(
      builder: (controller) {
        final bookings = controller.bookings;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: const Text(AppStrings.myBookings,
                style: AppTextStyles.heading3),
          ),
          body: bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox_rounded,
                          size: 64, color: AppColors.textHint),
                      const SizedBox(height: AppDimensions.paddingBase),
                      const Text('No bookings yet.',
                          style: AppTextStyles.bodyMedium),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.paddingBase),
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimensions.paddingM),
                  itemBuilder: (_, i) =>
                      _BookingCard(booking: bookings[i]),
                ),
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isNicu = booking.type == BookingType.nicuBed;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingBase),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isNicu
                  ? AppColors.patientPrimary.withOpacity(0.1)
                  : AppColors.ambulancePrimary.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(
              isNicu
                  ? Icons.bed_rounded
                  : Icons.airport_shuttle_rounded,
              color: isNicu
                  ? AppColors.patientPrimary
                  : AppColors.ambulancePrimary,
              size: AppDimensions.iconL,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.targetName,
                        style: AppTextStyles.cardTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _StatusChip(status: booking.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isNicu ? 'NICU Bed Request' : 'Ambulance Request',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(booking.date),
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: AppDimensions.fontXS,
                  ),
                ),
                if (booking.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    booking.notes!,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;
    switch (status) {
      case BookingStatus.pending:
        bg = AppColors.statusPendingBg;
        text = AppColors.statusPending;
        label = AppStrings.pending;
        break;
      case BookingStatus.confirmed:
        bg = AppColors.statusConfirmBg;
        text = AppColors.statusConfirm;
        label = AppStrings.confirm;
        break;
      case BookingStatus.completed:
        bg = AppColors.statusCompletedBg;
        text = AppColors.statusCompleted;
        label = AppStrings.completed;
        break;
      case BookingStatus.cancelled:
        bg = AppColors.statusCancelledBg;
        text = AppColors.statusCancelled;
        label = AppStrings.cancelled;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingXS),
      decoration: BoxDecoration(
          color: bg,
          borderRadius:
              BorderRadius.circular(AppDimensions.radiusFull)),
      child: Text(label,
          style: TextStyle(
              color: text,
              fontSize: AppDimensions.fontXS,
              fontWeight: FontWeight.w600)),
    );
  }
}
