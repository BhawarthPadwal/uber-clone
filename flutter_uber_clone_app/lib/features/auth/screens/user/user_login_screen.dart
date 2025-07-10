import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_strings.dart';
import 'package:flutter_uber_clone_app/utils/ui_helpers/ui_helpers.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _userLoginFormKey = GlobalKey<FormState>();
  AuthBloc authBloc = AuthBloc();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    authBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listenWhen: (previous, current) => current is AuthActionableState,
      buildWhen: (previous, current) => current is! AuthActionableState,
      listener: (context, state) {
        AppUiHelper.handleAuthState(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
                vertical: AppSizes.paddingM,
              ),
              child: Form(
                key: _userLoginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthWidgets.uberLabel(),
                    AppWidgets.heightBox(AppSizes.padding20),
                    AuthWidgets.label(AppString.enterEmail),
                    AppWidgets.heightBox(AppSizes.paddingM),
                    AuthWidgets.textField(
                      AppString.emailHint,
                      emailController,
                      isEmail: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppString.emailWarning;
                        }
                        return null;
                      },
                    ),
                    AppWidgets.heightBox(AppSizes.paddingM),
                    AuthWidgets.label(AppString.enterPassword),
                    AppWidgets.heightBox(AppSizes.paddingM),
                    AuthWidgets.textField(
                      AppString.passwordHint,
                      isPassword: true,
                      passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppString.passwordWarning;
                        }
                        return null;
                      },
                    ),
                    AppWidgets.heightBox(AppSizes.padding40),
                    AuthWidgets.submitButton(
                      text: AppString.login,
                      onPressed: () {
                        if (_userLoginFormKey.currentState!.validate()) {
                          authBloc.add(
                            UserLoginEvent(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            ),
                          );
                        } else {
                          AppWidgets.showSnackbar(
                            context,
                            message: AppString.warning,
                          );
                        }
                      },
                    ),
                    AppWidgets.heightBox(AppSizes.padding10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppString.newHere,
                          style: TextStyle(fontSize: AppSizes.fontSmall),
                        ),
                        AppWidgets.widthBox(AppSizes.padding10 * 0.5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.userSignupScreen,
                            );
                          },
                          child: Text(
                            AppString.createNewAccount,
                            style: TextStyle(
                              color: AppColors.bluishGrey,
                              fontSize: AppSizes.fontSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    AuthWidgets.submitButton(
                      text: AppString.signInAsCaptain,
                      backgroundColor: AppColors.lightGreen,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.captainLoginScreen,
                        );
                      },
                    ),
                    AppWidgets.heightBox(AppSizes.padding20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
