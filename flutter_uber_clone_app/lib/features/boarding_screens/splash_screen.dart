import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/services/api_service.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_assets.dart';


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
    final isLoggedIn = LocalStorageService.getCurrentAccess();
    AppLogger.d(token);

    if (!hasOnBoarded) {
      Navigator.pushReplacementNamed(context, AppRoutes.boardingScreen);
      return;
    }

    if (token == null || isLoggedIn == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.userLoginScreen);
      return;
    }

    final isTokenRefreshed = await ApiService.refreshToken();
    final nextRoute =
        isTokenRefreshed
            ? ((isLoggedIn == 'user')
                ? AppRoutes.homeScreen
                : AppRoutes.captainHomeScreen)
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
        backgroundColor: Color(0xffedeae6),
        body: SafeArea(
          child: Center(
            child: Image.asset(AppAssets.logo, width: 200, height: 200),
          ),
        ),
      ),
    );
  }
}
