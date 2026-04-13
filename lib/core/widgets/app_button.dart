// lib/core/widgets/app_button.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_text_styles.dart';

enum AppButtonStyle { primary, danger, outline, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final Color? color;
  final bool isLoading;
  final bool fullWidth;
  final double? height;
  final IconData? prefixIcon;
  final double? fontSize;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.color,
    this.isLoading = false,
    this.fullWidth = true,
    this.height,
    this.prefixIcon,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? _defaultColor;

    switch (style) {
      case AppButtonStyle.danger:
        return _buildElevated(AppColors.danger, AppColors.textWhite);
      case AppButtonStyle.outline:
        return _buildOutline(effectiveColor);
      case AppButtonStyle.ghost:
        return _buildGhost(effectiveColor);
      case AppButtonStyle.primary:
        return _buildElevated(effectiveColor, AppColors.textWhite);
    }
  }

  Color get _defaultColor => AppColors.hospitalPrimary;

  Widget _buildElevated(Color bg, Color fg) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        child: _buildChild(fg),
      ),
    );
  }

  Widget _buildOutline(Color borderColor) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? AppDimensions.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: borderColor,
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        child: _buildChild(borderColor),
      ),
    );
  }

  Widget _buildGhost(Color textColor) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? AppDimensions.buttonHeight,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(foregroundColor: textColor),
        child: _buildChild(textColor),
      ),
    );
  }

  Widget _buildChild(Color fg) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: fg, strokeWidth: 2),
      );
    }
    if (prefixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(prefixIcon, size: AppDimensions.iconM),
          const SizedBox(width: 8),
          Text(label,
              style: AppTextStyles.buttonText.copyWith(
                color: fg,
                fontSize: fontSize,
              )),
        ],
      );
    }
    return Text(
      label,
      style: AppTextStyles.buttonText.copyWith(color: fg, fontSize: fontSize),
    );
  }
}
