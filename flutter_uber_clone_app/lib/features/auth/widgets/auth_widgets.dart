import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';

class AuthWidgets {
  /// Title Label (e.g., "What's your email")
  static Widget label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppSizes.fontMedium,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Custom Text Form Field
  static Widget textField({
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: TextFormField(
        obscureText: isPassword,
        style: TextStyle(fontSize: AppSizes.fontMedium),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppSizes.paddingM),
        ),
        validator: validator,
      ),
    );
  }

  /// Custom Dropdown Field
  static Widget dropdownField({
    required String hint,
    required List<String> items,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        hint: Text(hint, style: TextStyle(fontSize: AppSizes.fontMedium)),
        decoration: const InputDecoration(border: InputBorder.none),
        style: TextStyle(fontSize: AppSizes.fontMedium),
        items:
            items.map((value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
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
