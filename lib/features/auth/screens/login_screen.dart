// lib/features/auth/screens/login_screen.dart
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
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late final UserRole _role;

  @override
  void initState() {
    super.initState();
    _role = Get.arguments as UserRole? ?? UserRole.hospital;
    // Pre-fill for demo
    switch (_role) {
      case UserRole.hospital:
        _emailController.text = 'admin@hospital.com';
        break;
      case UserRole.ambulance:
        _emailController.text = 'admin@ambulance.com';
        break;
      case UserRole.patient:
        _emailController.text = 'karim@gmail.com';
        break;
    }
    _passwordController.text = '123456';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Color get _primaryColor {
    switch (_role) {
      case UserRole.hospital:
        return AppColors.hospitalPrimary;
      case UserRole.ambulance:
        return AppColors.ambulancePrimary;
      case UserRole.patient:
        return AppColors.patientPrimary;
    }
  }

  String get _roleTitle {
    switch (_role) {
      case UserRole.hospital:
        return AppStrings.loginAsHospital;
      case UserRole.ambulance:
        return AppStrings.loginAsAmbulance;
      case UserRole.patient:
        return AppStrings.loginAsPatient;
    }
  }

  IconData get _roleIcon {
    switch (_role) {
      case UserRole.hospital:
        return Icons.local_hospital_rounded;
      case UserRole.ambulance:
        return Icons.airport_shuttle_rounded;
      case UserRole.patient:
        return Icons.person_rounded;
    }
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.find<AuthController>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
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
            icon: const Icon(Icons.arrow_back_rounded),
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
                      color: _primaryColor,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusXL),
                    ),
                    child: Icon(_roleIcon,
                        color: AppColors.textWhite, size: 36),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                Center(
                  child: Text(_roleTitle, style: AppTextStyles.heading2),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                const Center(
                  child: Text(
                    'Sign in to your account',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: AppStrings.username,
                        hint: AppStrings.enterEmailorPhone,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
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
                        controller: _passwordController,
                        obscureText: _obscurePassword,
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
                          onPressed: () {
                            setState(
                                () => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXL),
                      GetBuilder<AuthController>(
                        builder: (controller) => AppButton(
                          label: AppStrings.login,
                          onPressed: _onLogin,
                          isLoading: controller.isLoading,
                          color: _primaryColor,
                        ),
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
