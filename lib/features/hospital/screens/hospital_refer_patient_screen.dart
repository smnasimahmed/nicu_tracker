// lib/features/hospital/screens/hospital_refer_patient_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/hospital_model.dart';
import '../controllers/hospital_controller.dart';

class HospitalReferPatientScreen extends StatefulWidget {
  const HospitalReferPatientScreen({super.key});

  @override
  State<HospitalReferPatientScreen> createState() =>
      _HospitalReferPatientScreenState();
}

class _HospitalReferPatientScreenState
    extends State<HospitalReferPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _babyNameCtrl = TextEditingController();
  final _guardianContactCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  HospitalModel? _selectedHospital;
  bool _showDropdown = false;

  @override
  void dispose() {
    _babyNameCtrl.dispose();
    _guardianContactCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _onSend() {
    if (_selectedHospital == null) {
      setState(() {});
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      Get.find<HospitalController>().sendReferral(
        babyName: _babyNameCtrl.text.trim(),
        guardianContact: _guardianContactCtrl.text.trim(),
        reasonForTransfer: _reasonCtrl.text.trim(),
        toHospital: _selectedHospital!.name,
      );
      _babyNameCtrl.clear();
      _guardianContactCtrl.clear();
      _reasonCtrl.clear();
      setState(() => _selectedHospital = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingBase),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.border),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient Details
                  const Text(AppStrings.patientDetails,
                      style: AppTextStyles.heading3),
                  const SizedBox(height: AppDimensions.paddingBase),
                  AppTextField(
                    label: AppStrings.babyName,
                    hint: AppStrings.enterBabyName,
                    controller: _babyNameCtrl,
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),
                  AppTextField(
                    label: AppStrings.currentGuardianContact,
                    hint: AppStrings.guardianNameOrPhone,
                    controller: _guardianContactCtrl,
                    validator: (v) => (v == null || v.isEmpty)
                        ? AppStrings.guardianContactRequired
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),
                  AppTextField(
                    label: AppStrings.reasonForTransfer,
                    hint: AppStrings.describeReason,
                    controller: _reasonCtrl,
                    maxLines: 4,
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),

                  // Destination
                  const Text(AppStrings.destinationSelection,
                      style: AppTextStyles.heading3),
                  const SizedBox(height: AppDimensions.paddingBase),
                  const Text(AppStrings.selectDestinationHospital,
                      style: AppTextStyles.labelLarge),
                  const SizedBox(height: AppDimensions.paddingS),
                  _HospitalDropdown(
                    selected: _selectedHospital,
                    hospitals: DummyData.hospitals,
                    showDropdown: _showDropdown,
                    onTap: () =>
                        setState(() => _showDropdown = !_showDropdown),
                    onSelect: (h) => setState(() {
                      _selectedHospital = h;
                      _showDropdown = false;
                    }),
                  ),
                  if (_selectedHospital == null && !_showDropdown)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: AppDimensions.paddingXS,
                          left: AppDimensions.paddingM),
                      child: Text(
                        AppStrings.destinationRequired,
                        style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: AppDimensions.fontS),
                      ),
                    ),

                  const SizedBox(height: AppDimensions.paddingXL),
                  AppButton(
                    label: AppStrings.sendReferralRequest,
                    onPressed: _onSend,
                    color: AppColors.hospitalPrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HospitalDropdown extends StatelessWidget {
  final HospitalModel? selected;
  final List<HospitalModel> hospitals;
  final VoidCallback onTap;
  final bool showDropdown;
  final ValueChanged<HospitalModel> onSelect;

  const _HospitalDropdown({
    required this.selected,
    required this.hospitals,
    required this.onTap,
    required this.showDropdown,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingBase,
              vertical: AppDimensions.paddingM,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              border: Border.all(
                  color: showDropdown
                      ? AppColors.hospitalPrimary
                      : AppColors.border,
                  width: showDropdown ? 2 : 1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected?.name ?? AppStrings.chooseHospital,
                    style: selected != null
                        ? AppTextStyles.bodyMedium
                        : AppTextStyles.hintText,
                  ),
                ),
                Icon(
                  showDropdown
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (showDropdown)
          Container(
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              children: hospitals.map((h) {
                final isAvailable = h.availableBeds > 0;
                return InkWell(
                  onTap: isAvailable ? () => onSelect(h) : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingBase,
                      vertical: AppDimensions.paddingM,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${h.name} – ${h.availableBeds} '
                            '${h.availableBeds == 0 ? AppStrings.noBedsAvailable : AppStrings.bedsAvailable}',
                            style: TextStyle(
                              fontSize: AppDimensions.fontM,
                              color: isAvailable
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
