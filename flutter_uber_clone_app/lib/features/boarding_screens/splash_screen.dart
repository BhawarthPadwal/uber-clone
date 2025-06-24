import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_assets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    /*Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.boardingScreen);
    });*/
    _handleNavigation();
    super.initState();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    final hasOnBoarded = LocalStorageService.hasCompletedOnboarding();
    final token = LocalStorageService.getToken();

    if (!hasOnBoarded) {
      Navigator.pushReplacementNamed(context, AppRoutes.boardingScreen);
    } else if (token != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.userLoginScreen);
    }
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
