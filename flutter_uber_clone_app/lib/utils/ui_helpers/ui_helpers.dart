import '../../config/router/app_routes.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../widgets/app_widgets.dart';
import 'package:flutter/material.dart';

class AppUiHelper {
  static void handleAuthState(BuildContext context, AuthState state) {
    if (state is NavigateToHomeScreen) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
    } else if (state is AuthFailureState || state is AuthSuccessState) {
      final message =
          state is AuthFailureState
              ? state.message
              : (state as AuthSuccessState).message;

      AppWidgets.showSnackbar(context, message: message);
    }
  }
}
