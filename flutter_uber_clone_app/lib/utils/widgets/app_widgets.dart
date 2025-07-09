import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';

class AppWidgets {
  static SizedBox heightBox(double height) {
    return SizedBox(height: height);
  }

  static SizedBox widthBox(double width) {
    return SizedBox(width: width);
  }

  static void showSnackbar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    final bgColor = AppColors.black;

    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // optional
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        duration: duration,
        action: action,
      ),
    );
  }
}
