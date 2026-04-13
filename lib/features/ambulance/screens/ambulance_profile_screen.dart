// lib/features/ambulance/screens/ambulance_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/ambulance_controller.dart';

class AmbulanceProfileScreen extends StatefulWidget {
  const AmbulanceProfileScreen({super.key});

  @override
  State<AmbulanceProfileScreen> createState() =>
      _AmbulanceProfileScreenState();
}

class _AmbulanceProfileScreenState extends State<AmbulanceProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<AmbulanceController>();
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
    return GetBuilder<AmbulanceController>(
      builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingBase),
          child: Column(
            children: [
              // Avatar + name
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
                      backgroundColor: AppColors.ambulancePrimary,
                      child: Text(
                        controller.profileData.organizationName
                                ?.substring(0, 2)
                                .toUpperCase() ??
                            'RC',
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    Text(controller.profileData.organizationName ?? '',
                        style: AppTextStyles.heading3),
                    Text(controller.profileData.email,
                        style: AppTextStyles.bodySmall),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM,
                          vertical: AppDimensions.paddingXS),
                      decoration: BoxDecoration(
                        color:
                            AppColors.ambulancePrimary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: const Text('Ambulance Agency',
                          style: TextStyle(
                              color: AppColors.ambulancePrimary,
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
                      const Text('Contact Information',
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
                          if (_formKey.currentState?.validate() ?? false) {
                            controller.updateProfile(
                              name: _nameCtrl.text.trim(),
                              phone: _phoneCtrl.text.trim(),
                              address: _addressCtrl.text.trim(),
                            );
                          }
                        },
                        color: AppColors.ambulancePrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingBase),

              // Logout
              AppButton(
                label: AppStrings.logout,
                onPressed: () => Get.find<AuthController>().logout(),
                style: AppButtonStyle.outline,
                color: AppColors.danger,
              ),
            ],
          ),
        );
      },
    );
  }
}
