// lib/features/patient/screens/patient_register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/connectivity_wrapper.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/controllers/auth_controller.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() =>
      _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
    // Use auth controller to set current user and navigate
    final authCtrl = Get.find<AuthController>();
    authCtrl.selectedRole = UserRole.patient;
    authCtrl.login(_emailCtrl.text, _passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.patientPrimary,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusXL),
                    ),
                    child: const Icon(Icons.person_add_rounded,
                        color: AppColors.textWhite, size: 36),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                const Center(
                  child: Text('Create Account',
                      style: AppTextStyles.heading2),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                const Center(
                  child: Text(
                    'Register to book NICU beds & ambulances',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: AppStrings.fullName,
                        hint: AppStrings.enterFullName,
                        controller: _nameCtrl,
                        prefixIcon: const Icon(Icons.person_outline_rounded,
                            color: AppColors.textSecondary),
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
                        prefixIcon: const Icon(Icons.phone_outlined,
                            color: AppColors.textSecondary),
                        validator: (v) => (v == null || v.isEmpty)
                            ? AppStrings.phoneRequired
                            : null,
                      ),
                      const SizedBox(height: AppDimensions.paddingBase),
                      AppTextField(
                        label: AppStrings.username,
                        hint: AppStrings.enterEmailorPhone,
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.textSecondary),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.emailRequired;
                          }
                          if (!GetUtils.isEmail(v)) {
                            return AppStrings.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingBase),
                      AppTextField(
                        label: AppStrings.password,
                        hint: AppStrings.enterPassword,
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline_rounded,
                            color: AppColors.textSecondary),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.passwordRequired;
                          }
                          if (v.length < 6) {
                            return AppStrings.passwordTooShort;
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingBase),
                      AppTextField(
                        label: AppStrings.address,
                        hint: AppStrings.enterAddress,
                        controller: _addressCtrl,
                        maxLines: 2,
                        prefixIcon: const Icon(Icons.location_on_outlined,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXL),
                      AppButton(
                        label: AppStrings.register,
                        onPressed: _onRegister,
                        isLoading: _isLoading,
                        color: AppColors.patientPrimary,
                      ),
                      const SizedBox(height: AppDimensions.paddingBase),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(AppStrings.alreadyHaveAccount,
                              style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Text(
                              AppStrings.login,
                              style: TextStyle(
                                color: AppColors.patientPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: AppDimensions.fontBase,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
