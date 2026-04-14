// lib/features/hospital/screens/hospital_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/controllers/auth_controller.dart';

// Used as a modal bottom sheet from the AppBar avatar
class HospitalProfileSheet extends StatefulWidget {
  const HospitalProfileSheet({super.key});

  @override
  State<HospitalProfileSheet> createState() => _HospitalProfileSheetState();
}

class _HospitalProfileSheetState extends State<HospitalProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    final user = Get.find<AuthController>().currentUser;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _addressCtrl = TextEditingController(text: user?.address ?? '');
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
    final authCtrl = Get.find<AuthController>();
    final user = authCtrl.currentUser;
    final initials = user?.name.isNotEmpty == true
        ? user!.name.substring(0, 2).toUpperCase()
        : 'DR';

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
              const SizedBox(height: AppDimensions.paddingBase),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.paddingBase,
                    0,
                    AppDimensions.paddingBase,
                    AppDimensions.paddingXL,
                  ),
                  child: Column(
                    children: [
                      // Avatar card
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingXL),
                        decoration: BoxDecoration(
                          color: AppColors.hospitalPrimary.withOpacity(0.05),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusL),
                          border: Border.all(
                              color: AppColors.hospitalPrimary.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.hospitalPrimary,
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingBase),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user?.name ?? '',
                                      style: AppTextStyles.heading3),
                                  const SizedBox(height: 2),
                                  Text(user?.email ?? '',
                                      style: AppTextStyles.bodySmall),
                                  const SizedBox(height: AppDimensions.paddingXS),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppDimensions.paddingM,
                                        vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.hospitalAccentLight,
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusFull),
                                    ),
                                    child: Text(
                                      AppStrings.hospitalAdmin,
                                      style: const TextStyle(
                                        color: AppColors.hospitalAccent,
                                        fontSize: AppDimensions.fontXS,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingBase),

                      // Organization info (read-only)
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingBase),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusL),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.hospitalPrimary.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppDimensions.radiusM),
                              ),
                              child: const Icon(Icons.local_hospital_rounded,
                                  color: AppColors.hospitalPrimary,
                                  size: AppDimensions.iconM),
                            ),
                            const SizedBox(width: AppDimensions.paddingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Organization',
                                      style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: AppDimensions.fontS)),
                                  Text(
                                    user?.organizationName ?? '-',
                                    style: AppTextStyles.labelLarge,
                                  ),
                                ],
                              ),
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
                                    // AuthController handles profile save
                                    Get.back();
                                    Get.snackbar(
                                      AppStrings.profileSaved,
                                      '',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green.shade100,
                                      colorText: Colors.green.shade800,
                                      duration: const Duration(seconds: 2),
                                      margin: const EdgeInsets.all(12),
                                    );
                                  }
                                },
                                color: AppColors.hospitalPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingBase),

                      // Logout — clearly separated, less prominent
                      AppButton(
                        label: AppStrings.logout,
                        onPressed: () => authCtrl.logout(),
                        style: AppButtonStyle.outline,
                        color: AppColors.danger,
                      ),
                    ],
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
