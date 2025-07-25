import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/screens/captain/captain_login_screen.dart';
import 'package:flutter_uber_clone_app/features/auth/screens/captain/captain_signup_screen.dart';
import 'package:flutter_uber_clone_app/features/auth/screens/user/user_login_screen.dart';
import 'package:flutter_uber_clone_app/features/auth/screens/user/user_signup_screen.dart';
import 'package:flutter_uber_clone_app/features/boarding_screens/boarding_screen.dart';
import 'package:flutter_uber_clone_app/features/boarding_screens/splash_screen.dart';
import 'package:flutter_uber_clone_app/features/captain/screens/captain_home_screen.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/ride_created_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';

import '../../features/home/screens/home_screen.dart';

class Routes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return getPageTransition(SplashScreen(), settings);
      case AppRoutes.userLoginScreen:
        return getPageTransition(UserLoginScreen(), settings);
      case AppRoutes.userSignupScreen:
        return getPageTransition(UserSignupScreen(), settings);
      case AppRoutes.captainLoginScreen:
        return getPageTransition(CaptainLoginScreen(), settings);
      case AppRoutes.captainSignupScreen:
        return getPageTransition(CaptainSignupScreen(), settings);
      case AppRoutes.homeScreen:
        return getPageTransition(HomeScreen(), settings);
      case AppRoutes.boardingScreen:
        return getPageTransition(BoardingScreen(), settings);
      case AppRoutes.captainHomeScreen:
        return getPageTransition(CaptainHomeScreen(), settings);
      /*case AppRoutes.rideCreatedScreen:
          return getPageTransition(RideCreatedWidget(), settings);*/
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text("Invalid Route"))),
        );
    }
  }

  static getPageTransition(dynamic screenName, RouteSettings settings) {
    return PageTransition(
      child: screenName,
      type: PageTransitionType.theme,
      settings: settings,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 1000),
      maintainStateData: true,
      curve: Curves.easeInOut,
    );
  }
}
