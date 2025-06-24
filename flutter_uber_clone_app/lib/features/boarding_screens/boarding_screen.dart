import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/router/app_routes.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/widgets/app_widgets.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Stack(
                  children: [
                    Image.asset('assets/images/traffic_signal.jpg', fit: BoxFit.cover),
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Text(
                        'Uber',
                        style: TextStyle(
                          fontSize: AppSizes.fontXL,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppWidgets.heightBox(AppSizes.padding30),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Get Started with Uber',
                  style: TextStyle(fontSize: AppSizes.fontXXL, fontWeight: FontWeight.bold),
                ),
              ),
              AppWidgets.heightBox(AppSizes.padding30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.userLoginScreen,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppSizes.radiusM),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontMedium),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
