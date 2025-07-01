import '../../config/router/app_routes.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../widgets/app_widgets.dart';
import 'package:flutter/material.dart';

class AppUiHelper {
  static void handleAuthState(BuildContext context, AuthState state) {
    if (state is NavigateToUserHomeScreen) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
    } else if (state is NavigateToUserSignUpScreenState) {
      Navigator.pushReplacementNamed(context, AppRoutes.userSignupScreen);
    } else if (state is NavigateToUserLoginScreenState) {
      Navigator.pushReplacementNamed(context, AppRoutes.userLoginScreen);
    } else if (state is AuthFailureState || state is AuthSuccessState) {
      final message =
          state is AuthFailureState
              ? state.message
              : (state as AuthSuccessState).message;

      AppWidgets.showSnackbar(context, message: message);
    }
  }

  static void handleCapAuthState(BuildContext context, AuthState state) {
    if (state is NavigateToCaptainHomeScreen) {
      Navigator.pushReplacementNamed(context, AppRoutes.captainHomeScreen);
    } else if (state is NavigateToCaptainLoginScreenState) {
      Navigator.pushReplacementNamed(context, AppRoutes.captainLoginScreen);
    } else if (state is NavigateToCaptainSignUpScreenState) {
      Navigator.pushReplacementNamed(context, AppRoutes.captainSignupScreen);
    } else if (state is AuthFailureState || state is AuthSuccessState) {
      final message =
          state is AuthFailureState
              ? state.message
              : (state as AuthSuccessState).message;

      AppWidgets.showSnackbar(context, message: message);
    }
  }
}
