// lib/features/patient/screens/patient_book_nicu_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/hospital_model.dart';
import '../controllers/patient_controller.dart';

class PatientBookNicuScreen extends StatelessWidget {
  const PatientBookNicuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientController>(
      builder: (controller) {
        final hospitals = controller.filteredHospitals;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: const Text(AppStrings.bookNicuBed,
                style: AppTextStyles.heading3),
            actions: [
              // Nearby filter toggle
              Padding(
                padding: const EdgeInsets.only(right: AppDimensions.paddingBase),
                child: FilterChip(
                  label: const Text(AppStrings.filterNearby),
                  selected: controller.filterNearbyHospital,
                  onSelected: (_) => controller.toggleNearbyHospital(),
                  selectedColor: AppColors.patientPrimary.withOpacity(0.15),
                  checkmarkColor: AppColors.patientPrimary,
                  labelStyle: TextStyle(
                    color: controller.filterNearbyHospital
                        ? AppColors.patientPrimary
                        : AppColors.textSecondary,
                    fontSize: AppDimensions.fontS,
                    fontWeight: controller.filterNearbyHospital
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: controller.filterNearbyHospital
                        ? AppColors.patientPrimary
                        : AppColors.border,
                  ),
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                ),
              ),
            ],
          ),
          body: hospitals.isEmpty
              ? _EmptyState(
                  icon: Icons.bed_outlined,
                  message: controller.filterNearbyHospital
                      ? 'No hospitals with available beds nearby.'
                      : AppStrings.noBedsAvailable,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.paddingBase),
                  itemCount: hospitals.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimensions.paddingM),
                  itemBuilder: (_, i) =>
                      _HospitalCard(hospital: hospitals[i], controller: controller),
                ),
        );
      },
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final HospitalModel hospital;
  final PatientController controller;

  const _HospitalCard({required this.hospital, required this.controller});

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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.patientPrimary.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(Icons.local_hospital_rounded,
                    color: AppColors.patientPrimary,
                    size: AppDimensions.iconL),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hospital.name, style: AppTextStyles.cardTitle),
                    Text(hospital.address, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              if (hospital.distanceKm != null)
                _DistanceBadge(km: hospital.distanceKm!),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          const Divider(height: 0),
          const SizedBox(height: AppDimensions.paddingM),
          Row(
            children: [
              // Beds available indicator
              _BedIndicator(
                label: 'Available',
                count: hospital.availableBeds,
                color: AppColors.statusAvailable,
              ),
              const SizedBox(width: AppDimensions.paddingBase),
              _BedIndicator(
                label: 'Occupied',
                count: hospital.occupiedBeds,
                color: AppColors.statusOccupied,
              ),
              const SizedBox(width: AppDimensions.paddingBase),
              _BedIndicator(
                label: 'Total',
                count: hospital.totalBeds,
                color: AppColors.textSecondary,
              ),
              const Spacer(),
              SizedBox(
                width: 110,
                child: AppButton(
                  label: AppStrings.requestBed,
                  onPressed: () => _showBookingConfirm(context),
                  color: AppColors.patientPrimary,
                  height: 38,
                  fontSize: AppDimensions.fontS,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: const Text('Confirm Booking', style: AppTextStyles.heading3),
        content: Text(
          'Book a NICU bed at ${hospital.name}?\n\n'
          'Available beds: ${hospital.availableBeds}',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.cancel,
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => controller.bookNicuBed(hospital),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.patientPrimary,
              foregroundColor: AppColors.textWhite,
              elevation: 0,
            ),
            child: const Text(AppStrings.bookNow),
          ),
        ],
      ),
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  final double km;
  const _DistanceBadge({required this.km});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingXS),
      decoration: BoxDecoration(
        color: AppColors.statusAvailableBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_rounded,
              size: 12, color: AppColors.statusAvailable),
          const SizedBox(width: 3),
          Text(
            '${km.toStringAsFixed(1)} km',
            style: const TextStyle(
              color: AppColors.statusAvailable,
              fontSize: AppDimensions.fontXS,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BedIndicator extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _BedIndicator(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: color,
            fontSize: AppDimensions.fontL,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimensions.fontXS)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textHint),
          const SizedBox(height: AppDimensions.paddingBase),
          Text(message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
