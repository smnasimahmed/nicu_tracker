// lib/features/patient/screens/patient_book_ambulance_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/ambulance_model.dart';
import '../controllers/patient_controller.dart';

class PatientBookAmbulanceScreen extends StatelessWidget {
  const PatientBookAmbulanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientController>(
      builder: (controller) {
        final ambulances = controller.filteredAmbulances;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: const Text(AppStrings.bookAmbulance,
                style: AppTextStyles.heading3),
            actions: [
              // Filter chips row
              Padding(
                padding: const EdgeInsets.only(
                    right: AppDimensions.paddingBase),
                child: Row(
                  children: [
                    _FilterChip(
                      label: AppStrings.filterNearby,
                      selected: controller.filterNearbyAmbulance,
                      onTap: controller.toggleNearbyAmbulance,
                      color: AppColors.patientPrimary,
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    _FilterChip(
                      label: AppStrings.nicuEquipped,
                      selected: controller.filterNicuOnly,
                      onTap: controller.toggleNicuOnly,
                      color: AppColors.patientPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ambulances.isEmpty
              ? const _EmptyState(
                  icon: Icons.airport_shuttle_outlined,
                  message: 'No ambulances match your filters.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.paddingBase),
                  itemCount: ambulances.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimensions.paddingM),
                  itemBuilder: (_, i) =>
                      _AmbulanceCard(ambulance: ambulances[i], controller: controller),
                ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingXS + 2),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : AppColors.white,
          borderRadius:
              BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: selected ? color : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : AppColors.textSecondary,
            fontSize: AppDimensions.fontS,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _AmbulanceCard extends StatelessWidget {
  final AmbulanceModel ambulance;
  final PatientController controller;

  const _AmbulanceCard({required this.ambulance, required this.controller});

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
                  color: AppColors.statusAvailableBg,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(Icons.airport_shuttle_rounded,
                    color: AppColors.statusAvailable,
                    size: AppDimensions.iconL),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ambulance.vehicleName,
                        style: AppTextStyles.cardTitle),
                    Text(
                      ambulance.agencyName ?? '',
                      style: AppTextStyles.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Active badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: AppDimensions.paddingXS),
                decoration: BoxDecoration(
                  color: AppColors.statusAvailableBg,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle,
                        size: 7, color: AppColors.statusAvailable),
                    SizedBox(width: 4),
                    Text(AppStrings.active,
                        style: TextStyle(
                            color: AppColors.statusAvailable,
                            fontSize: AppDimensions.fontXS,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          const Divider(height: 0),
          const SizedBox(height: AppDimensions.paddingM),
          Row(
            children: [
              // Reg number
              Expanded(
                child: _InfoChip(
                  icon: Icons.numbers_rounded,
                  text: ambulance.registrationNumber,
                ),
              ),
              if (ambulance.hasNicuFacility)
                const _InfoChip(
                  icon: Icons.medical_services_rounded,
                  text: AppStrings.nicuEquipped,
                  color: AppColors.patientPrimary,
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          _InfoChip(
            icon: Icons.location_on_outlined,
            text: 'Serves: ${ambulance.serviceAreas.join(', ')}',
          ),
          const SizedBox(height: AppDimensions.paddingM),
          AppButton(
            label: AppStrings.bookNow,
            onPressed: () => _showBookingConfirm(context),
            color: AppColors.patientPrimary,
            height: 42,
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
          'Book ${ambulance.vehicleName} from ${ambulance.agencyName}?\n\n'
          'Reg: ${ambulance.registrationNumber}',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.cancel,
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => controller.bookAmbulance(ambulance),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.text,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
                color: color,
                fontSize: AppDimensions.fontS,
                fontWeight: color == AppColors.textSecondary
                    ? FontWeight.w400
                    : FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
