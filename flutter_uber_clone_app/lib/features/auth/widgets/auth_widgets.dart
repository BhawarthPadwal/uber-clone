import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_strings.dart';

class AuthWidgets {
  static Widget uberLabel() {
    return Text(
      AppString.appName,
      style: TextStyle(
        fontSize: AppSizes.fontLarge,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppSizes.fontMedium,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget textField(
    String hintText,
    TextEditingController controller, {
    String? Function(String?)? validator,
    bool isEmail = false,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(fontSize: AppSizes.fontSmall),
      validator: (value) {
        if (validator != null) {
          final customError = validator(value);
          if (customError != null) return customError;
        }

        if (isEmail) {
          if (value == null || value.isEmpty) {
            return AppString.emailWarning;
          }
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return AppString.invalidEmailWarning;
          }
        }

        return null; // All good
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.lightGrey,
        contentPadding: EdgeInsets.all(AppSizes.paddingM),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: BorderSide.none,
        ),
        errorStyle: TextStyle(
          fontSize: AppSizes.fontSmall,
          color: Colors.red,
          height: 1.2,
        ),
      ),
    );
  }

  static Widget submitButton({
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.black,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
