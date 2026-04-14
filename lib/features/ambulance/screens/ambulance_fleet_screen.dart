// lib/features/ambulance/screens/ambulance_fleet_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/ambulance_model.dart';
import '../controllers/ambulance_controller.dart';

class AmbulanceFleetScreen extends StatelessWidget {
  const AmbulanceFleetScreen({super.key});

  static void showAddForm(BuildContext context, AmbulanceController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AmbulanceFormSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AmbulanceController>(
      builder: (controller) {
        if (controller.ambulances.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.airport_shuttle_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.4)),
                const SizedBox(height: AppDimensions.paddingBase),
                const Text('No ambulances registered yet.',
                    style: AppTextStyles.bodyMedium),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          itemCount: controller.ambulances.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppDimensions.paddingM),
          itemBuilder: (_, i) =>
              _FleetCard(ambulance: controller.ambulances[i], controller: controller),
        );
      },
    );
  }
}

class _FleetCard extends StatelessWidget {
  final AmbulanceModel ambulance;
  final AmbulanceController controller;

  const _FleetCard({required this.ambulance, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isActive = ambulance.status == AmbulanceStatus.active;

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
          // Header row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.ambulancePrimary.withOpacity(0.1)
                      : AppColors.statusCancelledBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  Icons.airport_shuttle_rounded,
                  color: isActive
                      ? AppColors.ambulancePrimary
                      : AppColors.textSecondary,
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
              // Edit button
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.ambulancePrimary,
                    size: AppDimensions.iconM),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) =>
                      _AmbulanceFormSheet(controller: controller, existing: ambulance),
                ),
              ),
            ],
          ),
          const Divider(height: AppDimensions.paddingXL),

          // Details
          if (ambulance.serviceAreas.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: AppDimensions.iconS,
                    color: AppColors.textSecondary),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: Text(
                    ambulance.serviceAreas.join(', '),
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingS),
          ],

          if (ambulance.hasNicuFacility)
            Row(
              children: [
                const Icon(Icons.local_hospital_outlined,
                    size: AppDimensions.iconS,
                    color: AppColors.ambulancePrimary),
                const SizedBox(width: AppDimensions.paddingS),
                Text(AppStrings.nicuIcuAvailable,
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.ambulancePrimary,
                        fontWeight: FontWeight.w600)),
              ],
            ),

          const SizedBox(height: AppDimensions.paddingBase),

          // Active toggle row
          Row(
            children: [
              Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: AppDimensions.fontS,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? AppColors.statusAvailable
                      : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Switch.adaptive(
                value: isActive,
                onChanged: (_) => controller.toggleStatus(ambulance.id),
                activeColor: AppColors.statusAvailable,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Add / Edit Form — bottom sheet ───────────────────────────────────────

class _AmbulanceFormSheet extends StatefulWidget {
  final AmbulanceController controller;
  final AmbulanceModel? existing;

  const _AmbulanceFormSheet({required this.controller, this.existing});

  @override
  State<_AmbulanceFormSheet> createState() => _AmbulanceFormSheetState();
}

class _AmbulanceFormSheetState extends State<_AmbulanceFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _regCtrl;
  late final TextEditingController _nameCtrl;
  bool _hasNicu = false;
  late List<String> _selectedAreas;

  bool get isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _regCtrl = TextEditingController(
        text: widget.existing?.registrationNumber ?? '');
    _nameCtrl =
        TextEditingController(text: widget.existing?.vehicleName ?? '');
    _hasNicu = widget.existing?.hasNicuFacility ?? false;
    _selectedAreas = List.from(widget.existing?.serviceAreas ?? []);
  }

  @override
  void dispose() {
    _regCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (isEditing) {
      widget.controller.editAmbulance(
        id: widget.existing!.id,
        registrationNumber: _regCtrl.text.trim(),
        vehicleName: _nameCtrl.text.trim(),
        hasNicuFacility: _hasNicu,
        serviceAreas: _selectedAreas,
      );
    } else {
      widget.controller.addAmbulance(
        registrationNumber: _regCtrl.text.trim(),
        vehicleName: _nameCtrl.text.trim(),
        hasNicuFacility: _hasNicu,
        serviceAreas: _selectedAreas,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusXL)),
          ),
          child: Column(
            children: [
              // Drag handle
              const SizedBox(height: AppDimensions.paddingM),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
              // Sheet header
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingBase,
                    vertical: AppDimensions.paddingM),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing
                                ? AppStrings.editAmbulance
                                : AppStrings.addAmbulance,
                            style: AppTextStyles.heading3,
                          ),
                          Text(
                            isEditing
                                ? AppStrings.updateAmbulanceDesc
                                : AppStrings.addAmbulanceDesc,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textSecondary),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),

              // Scrollable form
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(AppDimensions.paddingBase),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: AppStrings.registrationNumber,
                          hint: AppStrings.registrationHint,
                          controller: _regCtrl,
                          validator: (v) => (v == null || v.isEmpty)
                              ? AppStrings.registrationRequired
                              : null,
                        ),
                        const SizedBox(height: AppDimensions.paddingBase),

                        AppTextField(
                          label: AppStrings.vehicleName,
                          hint: AppStrings.vehicleNameHint,
                          controller: _nameCtrl,
                          validator: (v) => (v == null || v.isEmpty)
                              ? AppStrings.vehicleNameRequired
                              : null,
                        ),
                        const SizedBox(height: AppDimensions.paddingBase),

                        // NICU toggle
                        Container(
                          padding:
                              const EdgeInsets.all(AppDimensions.paddingM),
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusM),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: const [
                                    Text(AppStrings.nicuIcuAvailable,
                                        style: AppTextStyles.labelLarge),
                                    Text(AppStrings.nicuIcuDesc,
                                        style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: _hasNicu,
                                onChanged: (v) =>
                                    setState(() => _hasNicu = v),
                                activeColor: AppColors.ambulancePrimary,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingBase),

                        // Service areas
                        const Text(AppStrings.serviceArea,
                            style: AppTextStyles.labelLarge),
                        const SizedBox(height: AppDimensions.paddingS),
                        Wrap(
                          spacing: AppDimensions.paddingS,
                          runSpacing: AppDimensions.paddingS,
                          children: DummyData.serviceAreas.map((area) {
                            final selected = _selectedAreas.contains(area);
                            return FilterChip(
                              label: Text(area),
                              selected: selected,
                              onSelected: (val) {
                                setState(() {
                                  if (val) {
                                    _selectedAreas.add(area);
                                  } else {
                                    _selectedAreas.remove(area);
                                  }
                                });
                              },
                              selectedColor: AppColors.ambulancePrimary
                                  .withOpacity(0.15),
                              checkmarkColor: AppColors.ambulancePrimary,
                              labelStyle: TextStyle(
                                color: selected
                                    ? AppColors.ambulancePrimary
                                    : AppColors.textPrimary,
                                fontSize: AppDimensions.fontS,
                              ),
                              side: BorderSide(
                                color: selected
                                    ? AppColors.ambulancePrimary
                                    : AppColors.border,
                              ),
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusFull),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppDimensions.paddingXL),

                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: AppStrings.cancel,
                                onPressed: () => Get.back(),
                                style: AppButtonStyle.outline,
                                color: AppColors.textSecondary,
                                fullWidth: false,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingM),
                            Expanded(
                              child: AppButton(
                                label: AppStrings.saveAmbulanceDetails,
                                onPressed: _submit,
                                color: AppColors.ambulancePrimary,
                                fullWidth: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.paddingBase),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
