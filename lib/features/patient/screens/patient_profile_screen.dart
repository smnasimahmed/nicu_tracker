// lib/features/patient/screens/patient_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/patient_controller.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() =>
      _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<PatientController>();
    _nameCtrl = TextEditingController(text: controller.profileData.name);
    _phoneCtrl =
        TextEditingController(text: controller.profileData.phone ?? '');
    _addressCtrl =
        TextEditingController(text: controller.profileData.address ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: const Text(AppStrings.profile,
                style: AppTextStyles.heading3),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingBase),
            child: Column(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingXL),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.patientPrimary,
                        child: Text(
                          controller.profileData.name.isNotEmpty
                              ? controller.profileData.name
                                  .substring(0, 1)
                                  .toUpperCase()
                              : 'P',
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      Text(controller.profileData.name,
                          style: AppTextStyles.heading3),
                      Text(controller.profileData.email,
                          style: AppTextStyles.bodySmall),
                      const SizedBox(height: AppDimensions.paddingXS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingXS),
                        decoration: BoxDecoration(
                          color: AppColors.patientPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull),
                        ),
                        child: const Text('Patient / Guardian',
                            style: TextStyle(
                                color: AppColors.patientPrimary,
                                fontSize: AppDimensions.fontS,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingBase),

                // Edit form
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingXL),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Personal Information',
                            style: AppTextStyles.heading3),
                        const SizedBox(height: AppDimensions.paddingBase),
                        AppTextField(
                          label: AppStrings.fullName,
                          hint: AppStrings.enterFullName,
                          controller: _nameCtrl,
                          validator: (v) => (v == null || v.isEmpty)
                              ? AppStrings.nameRequired
                              : null,
                        ),
                        const SizedBox(height: AppDimensions.paddingBase),
                        AppTextField(
                          label: AppStrings.phoneNumber,
                          hint: AppStrings.enterPhone,
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.isEmpty)
                              ? AppStrings.phoneRequired
                              : null,
                        ),
                        const SizedBox(height: AppDimensions.paddingBase),
                        AppTextField(
                          label: AppStrings.address,
                          hint: AppStrings.enterAddress,
                          controller: _addressCtrl,
                          maxLines: 2,
                        ),
                        const SizedBox(height: AppDimensions.paddingXL),
                        AppButton(
                          label: AppStrings.saveProfile,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ??
                                false) {
                              controller.updateProfile(
                                name: _nameCtrl.text.trim(),
                                phone: _phoneCtrl.text.trim(),
                                address: _addressCtrl.text.trim(),
                              );
                            }
                          },
                          color: AppColors.patientPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingBase),

                // Logout
                AppButton(
                  label: AppStrings.logout,
                  onPressed: () =>
                      Get.find<AuthController>().logout(),
                  style: AppButtonStyle.outline,
                  color: AppColors.danger,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
