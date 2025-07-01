import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';

import '../../../../utils/ui_helpers/ui_helpers.dart';
import '../../../../utils/widgets/app_widgets.dart';

class CaptainLoginScreen extends StatefulWidget {
  const CaptainLoginScreen({super.key});

  @override
  State<CaptainLoginScreen> createState() => _CaptainLoginScreenState();
}

class _CaptainLoginScreenState extends State<CaptainLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _captainLoginFormKey = GlobalKey<FormState>();
  AuthBloc authBloc = AuthBloc();

  @override
  void dispose() {
    super.dispose();
    authBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listenWhen: (previous, current) => current is AuthActionableState,
      buildWhen: (previous, current) => current is! AuthActionableState,
      listener: (context, state) {
        AppUiHelper.handleCapAuthState(context, state);
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
                key: _captainLoginFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthWidgets.uberLabel(),
                      Icon(Icons.arrow_forward, size: AppSizes.padding30),
                      AppWidgets.heightBox(AppSizes.padding20),
                      AuthWidgets.label("What's your email"),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.textField(
                        isEmail: true,
                        "email@example.com",
                        emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your email';
                          }
                          return null;
                        },
                      ),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.label("Enter Password"),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.textField(
                        "Password",
                        isPassword: true,
                        passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                      AppWidgets.heightBox(AppSizes.padding40),
                      AuthWidgets.submitButton(
                        text: "Login",
                        onPressed: () {
                          if (_captainLoginFormKey.currentState!.validate()) {
                            authBloc.add(
                              CaptainLoginEvent(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                          } else {
                            AppWidgets.showSnackbar(
                              context,
                              message: 'Kindly fill all fields',
                            );
                          }
                        },
                      ),
                      AppWidgets.heightBox(AppSizes.padding10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Join a fleet?',
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.captainSignupScreen,
                                );
                              },
                              child: Text(
                                'Register as a Captain',
                                style: TextStyle(
                                  color: AppColors.bluishGrey,
                                  fontSize: AppSizes.fontSmall,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppWidgets.heightBox(330),
                      AuthWidgets.submitButton(
                        text: "Sign in as User",
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.userLoginScreen,
                          );
                        },
                        backgroundColor: AppColors.orange,
                      ),
                      AppWidgets.heightBox(AppSizes.padding20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
