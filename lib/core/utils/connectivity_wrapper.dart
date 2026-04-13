// lib/core/widgets/connectivity_wrapper.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicu_tracker/core/utils/connectivity_controller.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityController>(
      builder: (controller) {
        if (!controller.isConnected) {
          return const _NoInternetScreen();
        }
        return child;
      },
    );
  }
}

class _NoInternetScreen extends StatelessWidget {
  const _NoInternetScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingXXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: AppDimensions.iconXXL,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              const Text(
                AppStrings.noInternet,
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              const Text(
                AppStrings.noInternetMessage,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              SizedBox(
                width: 160,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.find<ConnectivityController>().checkConnectivity();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: AppDimensions.iconM),
                  label: const Text(AppStrings.retry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
