// lib/features/hospital/screens/hospital_nicu_beds_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/nicu_bed_model.dart';
import '../controllers/hospital_controller.dart';

class HospitalNicuBedsScreen extends StatelessWidget {
  const HospitalNicuBedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HospitalController>(
      builder: (controller) {
        return Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingBase,
                AppDimensions.paddingBase,
                AppDimensions.paddingBase,
                80, // extra bottom padding for FAB
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: AppDimensions.paddingM,
                mainAxisSpacing: AppDimensions.paddingM,
                childAspectRatio: MediaQuery.of(context).size.width > 600
                    ? 0.9
                    : 0.78,
              ),
              itemCount: controller.beds.length,
              itemBuilder: (_, i) =>
                  _BedCard(bed: controller.beds[i], controller: controller),
            ),

            // ── Add New Bed FAB ────────────────────────────────────────
            Positioned(
              right: AppDimensions.paddingBase,
              bottom: AppDimensions.paddingBase,
              child: FloatingActionButton.extended(
                onPressed: () => _showAddBedDialog(context, controller),
                backgroundColor: AppColors.hospitalPrimary,
                icon: const Icon(Icons.add_rounded, color: AppColors.textWhite),
                label: const Text(
                  AppStrings.addNewBed,
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddBedDialog(BuildContext context, HospitalController controller) {
    showDialog(
      context: context,
      builder: (_) => _AddBedDialog(controller: controller),
    );
  }
}

class _BedCard extends StatelessWidget {
  final NicuBedModel bed;
  final HospitalController controller;

  const _BedCard({required this.bed, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isOccupied = bed.status == BedStatus.occupied;
    final isAvailable = bed.status == BedStatus.available;
    final isInTransit = bed.status == BedStatus.inTransit;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Bed Code + Status centered, delete top-right ──────────
            Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(bed.bedCode, style: AppTextStyles.cardTitle),
                      const SizedBox(height: 4),
                      BedStatusBadge(status: bed.status),
                    ],
                  ),
                ),
                isOccupied || isInTransit
                    ? SizedBox.shrink()
                    : Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showDeleteDialog(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.statusOccupiedBg,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusS,
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.statusOccupied,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingS),

            if (isOccupied) ...[
              const Divider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(label: 'Baby: ', value: bed.babyName ?? 'Unknown'),
                    _InfoRow(
                      label: 'Guardian: ',
                      value: bed.guardianName ?? '-',
                    ),
                    _InfoRow(label: 'Phone: ', value: bed.guardianPhone ?? '-'),
                    _InfoRow(
                      label: 'Admitted: ',
                      value: bed.admittedDate != null
                          ? '${bed.admittedDate!.year}-'
                                '${bed.admittedDate!.month.toString().padLeft(2, '0')}-'
                                '${bed.admittedDate!.day.toString().padLeft(2, '0')}'
                          : '-',
                    ),
                  ],
                ),
              ),
              AppButton(
                label: AppStrings.discharge,
                onPressed: () => _showDischargeDialog(context),
                style: AppButtonStyle.danger,
                height: 38,
                fontSize: AppDimensions.fontS,
              ),
            ],

            if (isAvailable) ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingM),
                        decoration: BoxDecoration(
                          color: AppColors.statusAvailableBg,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                        child: const Icon(
                          Icons.qr_code_rounded,
                          size: 40,
                          color: AppColors.statusAvailable,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXS),
                      const Text(
                        AppStrings.scanToAdmit,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              AppButton(
                label: AppStrings.admit,
                onPressed: () => _showAdmitDialog(context),
                color: AppColors.hospitalAccent,
                height: 38,
                fontSize: AppDimensions.fontS,
              ),
            ],

            if (isInTransit) ...[
              const Expanded(
                child: Center(
                  child: Text(
                    AppStrings.patientIncoming,
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAdmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _AdmitDialog(bed: bed, controller: controller),
    );
  }

  void _showDischargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: const Text(
          AppStrings.confirmDischarge,
          style: AppTextStyles.heading3,
        ),
        content: const Text(
          AppStrings.confirmDischargeMessage,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: AppStrings.discharge,
                  style: AppButtonStyle.danger,
                  onPressed: () {
                    Get.back();
                    controller.dischargePatient(bed.id);
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: const Text(AppStrings.deleteBed, style: AppTextStyles.heading3),
        content: Text(
          'Are you sure you want to delete bed ${bed.bedCode}? This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: AppStrings.delete,
                  style: AppButtonStyle.danger,
                  onPressed: () {
                    Get.back();
                    controller.deleteBed(bed.id);
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
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: AppDimensions.fontS,
            color: AppColors.textPrimary,
          ),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ─── Admit Dialog ──────────────────────────────────────────────────────────

class _AdmitDialog extends StatefulWidget {
  final NicuBedModel bed;
  final HospitalController controller;

  const _AdmitDialog({required this.bed, required this.controller});

  @override
  State<_AdmitDialog> createState() => _AdmitDialogState();
}

class _AdmitDialogState extends State<_AdmitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _babyNameCtrl = TextEditingController();
  final _guardianNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _relation = 'Father';

  @override
  void dispose() {
    _babyNameCtrl.dispose();
    _guardianNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.controller.admitPatient(
        bedId: widget.bed.id,
        babyName: _babyNameCtrl.text.trim(),
        guardianName: _guardianNameCtrl.text.trim(),
        guardianRelation: _relation,
        guardianPhone: _phoneCtrl.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingBase,
        vertical: AppDimensions.paddingXXL,
      ),
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
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.heading3,
                          children: [
                            TextSpan(text: 'Bed ${widget.bed.bedCode} '),
                            const TextSpan(
                              text: '(${AppStrings.readyForAdmission})',
                              style: TextStyle(
                                color: AppColors.statusAvailable,
                                fontSize: AppDimensions.fontM,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: Get.back,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                const Text(
                  AppStrings.relation,
                  style: AppTextStyles.labelLarge,
                ),
                const SizedBox(height: AppDimensions.paddingS),
                DropdownButtonFormField<String>(
                  value: _relation,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.hospitalPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                  items: ['Father', 'Mother', 'Guardian', 'Other']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _relation = v!),
                ),

                const SizedBox(height: AppDimensions.paddingBase),

                AppTextField(
                  label: AppStrings.contactName,
                  hint: AppStrings.enterGuardianName,
                  controller: _guardianNameCtrl,
                  validator: (v) => (v == null || v.isEmpty)
                      ? AppStrings.fieldRequired
                      : null,
                ),

                const SizedBox(height: AppDimensions.paddingBase),

                AppTextField(
                  label: AppStrings.phoneNo,
                  hint: AppStrings.phoneHint,
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.isEmpty)
                      ? AppStrings.fieldRequired
                      : null,
                ),

                const SizedBox(height: AppDimensions.paddingBase),

                const Text(
                  AppStrings.babyName,
                  style: AppTextStyles.labelLarge,
                ),
                const SizedBox(height: AppDimensions.paddingS),
                TextFormField(
                  controller: _babyNameCtrl,
                  decoration: InputDecoration(
                    hintText: AppStrings.enterBabyName,
                    hintStyle: AppTextStyles.hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.hospitalPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingXL),

                AppButton(
                  label: AppStrings.confirmOccupyBed,
                  onPressed: _submit,
                  color: AppColors.hospitalPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Add Bed Dialog ────────────────────────────────────────────────────────

class _AddBedDialog extends StatefulWidget {
  final HospitalController controller;
  const _AddBedDialog({required this.controller});

  @override
  State<_AddBedDialog> createState() => _AddBedDialogState();
}

class _AddBedDialogState extends State<_AddBedDialog> {
  final _formKey = GlobalKey<FormState>();
  final _bedCodeCtrl = TextEditingController();

  @override
  void dispose() {
    _bedCodeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.controller.addBed();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      title: const Text(AppStrings.addNewBed, style: AppTextStyles.heading3),
      content: Form(
        key: _formKey,
        child: const Text('Are you sure?', style: AppTextStyles.bodyLarge),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: AppStrings.addBed,
                onPressed: _submit,
                color: AppColors.hospitalPrimary,
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
    );
  }
}
