import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/services/api_service.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_assets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:jwt_decoder/jwt_decoder.dart';



import '../../utils/logger/app_logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    _handleNavigation();
    super.initState();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    final hasOnBoarded = LocalStorageService.hasCompletedOnboarding();
    final token = LocalStorageService.getToken();
    AppLogger.d(token);

    if (!hasOnBoarded) {
      Navigator.pushReplacementNamed(context, AppRoutes.boardingScreen);
    }

    if (token == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.userLoginScreen);
    }

    final isTokenRefreshed = await ApiService.refreshToken();
    final nextRoute = isTokenRefreshed
        ? AppRoutes.homeScreen
        : AppRoutes.userLoginScreen;

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Center(
            child: Image.asset(AppAssets.splashLogo, width: 200, height: 200),
          ),
        ),
      ),
    );
  }
}
