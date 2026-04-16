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
  final _guardianNameCtrl = TextEditingController();
  final _guardianPhoneCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  String _relation = 'Father';
  HospitalModel? _selectedHospital;
  bool _showDropdown = false;

  @override
  void dispose() {
    _babyNameCtrl.dispose();
    _guardianNameCtrl.dispose();
    _guardianPhoneCtrl.dispose();
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
        guardianContact:
            '${_guardianNameCtrl.text.trim()} (${_guardianPhoneCtrl.text.trim()})',
        reasonForTransfer: _reasonCtrl.text.trim(),
        toHospital: _selectedHospital!.name,
      );
      _babyNameCtrl.clear();
      _guardianNameCtrl.clear();
      _guardianPhoneCtrl.clear();
      _reasonCtrl.clear();
      setState(() {
        _selectedHospital = null;
        _relation = 'Father';
      });
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
                  const Text(
                    AppStrings.patientDetails,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),
                  AppTextField(
                    label: AppStrings.babyName,
                    hint: AppStrings.enterBabyName,
                    controller: _babyNameCtrl,
                    prefixIcon: Icon(Icons.child_care_rounded),
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),

                  // Relation dropdown
                  const Text(
                    AppStrings.relation,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  DropdownButtonFormField<String>(
                    value: _relation,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                        borderSide: const BorderSide(
                            color: AppColors.hospitalPrimary, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.inputFill,
                    ),
                    items: ['Father', 'Mother', 'Guardian', 'Other']
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (v) => setState(() => _relation = v!),
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),

                  // Guardian Name
                  AppTextField(
                    label: AppStrings.guardianName,
                    hint: AppStrings.enterGuardianName,
                    controller: _guardianNameCtrl,
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    validator: (v) => (v == null || v.isEmpty)
                        ? AppStrings.fieldRequired
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),

                  // Guardian Phone
                  AppTextField(
                    label: AppStrings.guardianPhone,
                    hint: AppStrings.phoneHint,
                    controller: _guardianPhoneCtrl,
                    prefixIcon: Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.isEmpty)
                        ? AppStrings.fieldRequired
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),

                  AppTextField(
                    label: AppStrings.reasonForTransfer,
                    hint: AppStrings.describeReason,
                    controller: _reasonCtrl,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),

                  // Destination
                  const Text(
                    AppStrings.destinationSelection,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppDimensions.paddingBase),
                  const Text(
                    AppStrings.selectDestinationHospital,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  _HospitalSelector(
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
                  if (_selectedHospital != null) ...[
                    const SizedBox(height: AppDimensions.paddingM),
                    _SelectedHospitalCard(hospital: _selectedHospital!),
                  ],
                  if (_selectedHospital == null && !_showDropdown)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: AppDimensions.paddingXS,
                          left: AppDimensions.paddingM),
                      child: Text(
                        AppStrings.destinationRequired,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: AppDimensions.fontS,
                        ),
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

// ─── Hospital Selector Dropdown ────────────────────────────────────────────

class _HospitalSelector extends StatelessWidget {
  final HospitalModel? selected;
  final List<HospitalModel> hospitals;
  final VoidCallback onTap;
  final bool showDropdown;
  final ValueChanged<HospitalModel> onSelect;

  const _HospitalSelector({
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
                width: showDropdown ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              children: [
                Icon(Icons.apartment, color: AppColors.hospitalPrimaryLight),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: Text(
                    selected != null
                        ? selected!.name
                        : AppStrings.chooseHospital,
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
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: hospitals.asMap().entries.map((entry) {
                final i = entry.key;
                final h = entry.value;
                final isAvailable = h.availableBeds > 0;
                final isSelected = selected?.id == h.id;
                return Column(
                  children: [
                    InkWell(
                      onTap: isAvailable ? () => onSelect(h) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingBase,
                          vertical: AppDimensions.paddingM,
                        ),
                        child: Row(
                          children: [
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: AppDimensions.paddingS),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: AppColors.hospitalPrimary,
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${h.name} \u2013 ${h.availableBeds} '
                                    '${h.availableBeds == 0 ? AppStrings.noBedsAvailable : AppStrings.bedsAvailable}',
                                    style: TextStyle(
                                      fontSize: AppDimensions.fontM,
                                      fontWeight: FontWeight.w500,
                                      color: isAvailable
                                          ? AppColors.textPrimary
                                          : AppColors.textHint,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _locationLabel(h),
                                    style: TextStyle(
                                      fontSize: AppDimensions.fontS,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < hospitals.length - 1)
                      Divider(height: 1, color: AppColors.border),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  String _locationLabel(HospitalModel h) {
    // Use district/division if available, otherwise derive from address
    if (h.district != null && h.division != null) {
      return '${h.district}, ${h.division}';
    }
    return h.address;
  }
}

// ─── Selected Hospital Card ────────────────────────────────────────────────

class _SelectedHospitalCard extends StatelessWidget {
  final HospitalModel hospital;
  const _SelectedHospitalCard({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingBase),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hospital.name, style: AppTextStyles.cardTitle),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                hospital.district != null && hospital.division != null
                    ? '${hospital.district}, ${hospital.division}'
                    : hospital.address,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${hospital.availableBeds} beds available',
            style: TextStyle(
              fontSize: AppDimensions.fontS,
              color: AppColors.statusAvailable,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}