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

  // Called from AmbulanceMainScreen's AppBar action button
  static void showAddForm(BuildContext context, AmbulanceController controller) {
    showDialog(
      context: context,
      builder: (_) => _AmbulanceFormDialog(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AmbulanceController>(
      builder: (controller) {
        if (controller.ambulances.isEmpty) {
          return const Center(child: Text('No ambulances registered yet.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          child: Column(
            children: [
              _TableHeader(),
              const SizedBox(height: AppDimensions.paddingXS),
              ...controller.ambulances.map((amb) => _FleetRow(
                    ambulance: amb,
                    controller: controller,
                  )),
            ],
          ),
        );
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingBase,
          vertical: AppDimensions.paddingM),
      child: const Row(
        children: [
          _Cell('Reg. Number', flex: 3),
          _Cell('Vehicle', flex: 2),
          _Cell('Area', flex: 2),
          _Cell('Status', flex: 2),
          _Cell('Actions', flex: 2),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final int flex;
  const _Cell(this.text, {this.flex = 1});

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

class _FleetRow extends StatelessWidget {
  final AmbulanceModel ambulance;
  final AmbulanceController controller;

  const _FleetRow({required this.ambulance, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isActive = ambulance.status == AmbulanceStatus.active;
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
          Expanded(
              flex: 3,
              child: Text(ambulance.registrationNumber,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
              flex: 2,
              child: Text(ambulance.vehicleName,
                  style: AppTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
            flex: 2,
            child: Text(ambulance.serviceAreas.join(', '),
                style: AppTextStyles.bodySmall,
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Switch.adaptive(
              value: isActive,
              onChanged: (_) => controller.toggleStatus(ambulance.id),
              activeColor: AppColors.statusAvailable,
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: AppColors.ambulancePrimary,
                  size: AppDimensions.iconM),
              onPressed: () => showDialog(
                context: context,
                builder: (_) =>
                    _AmbulanceFormDialog(controller: controller, existing: ambulance),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add / Edit Form Dialog ────────────────────────────────────────────────

class _AmbulanceFormDialog extends StatefulWidget {
  final AmbulanceController controller;
  final AmbulanceModel? existing;

  const _AmbulanceFormDialog({required this.controller, this.existing});

  @override
  State<_AmbulanceFormDialog> createState() => _AmbulanceFormDialogState();
}

class _AmbulanceFormDialogState extends State<_AmbulanceFormDialog> {
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
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL)),
      insetPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingBase,
          vertical: AppDimensions.paddingXXL),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                const SizedBox(height: AppDimensions.paddingXL),

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

                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        onChanged: (v) => setState(() => _hasNicu = v),
                        activeColor: AppColors.ambulancePrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingBase),

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
                      selectedColor:
                          AppColors.ambulancePrimary.withOpacity(0.15),
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
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppDimensions.paddingBase),

                const Text(AppStrings.vehiclePhotos,
                    style: AppTextStyles.labelLarge),
                const SizedBox(height: AppDimensions.paddingS),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.upload_rounded,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconXL),
                      const SizedBox(height: AppDimensions.paddingXS),
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.bodySmall,
                          children: [
                            const TextSpan(
                                text: 'Drag & drop images here, or '),
                            TextSpan(
                              text: 'browse',
                              style: const TextStyle(
                                  color: AppColors.ambulancePrimary,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
