import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_strings.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';

import '../../../../utils/ui_helpers/ui_helpers.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameControlller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  final _userSignUpFormKey = GlobalKey<FormState>();
  AuthBloc authBloc = AuthBloc();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameControlller.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
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
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _userSignUpFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthWidgets.uberLabel(),
                      AppWidgets.heightBox(AppSizes.padding20),
                      AuthWidgets.label(AppString.enterName),
                      AppWidgets.heightBox(AppSizes.padding10),
                      Row(
                        children: [
                          Expanded(
                            child: AuthWidgets.textField(
                              AppString.firstNameLabel,
                              firstNameController,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? AppString.firstNameWarning
                                          : null,
                            ),
                          ),
                          AppWidgets.widthBox(AppSizes.padding20),
                          Expanded(
                            child: AuthWidgets.textField(
                              AppString.lastNameLabel,
                              lastNameControlller,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? AppString.lastNameWarning
                                          : null,
                            ),
                          ),
                        ],
                      ),
                      AppWidgets.heightBox(AppSizes.padding10),
                      AuthWidgets.label(AppString.enterEmail),
                      AppWidgets.heightBox(AppSizes.padding10),
                      AuthWidgets.textField(
                        AppString.emailHint,
                        emailController,
                        isEmail: true,
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? AppString.emailWarning
                                    : null,
                      ),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.label(AppString.enterPassword),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.textField(
                        AppString.passwordHint,
                        passwordController,
                        isPassword: true,
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? AppString.passwordWarning
                                    : null,
                      ),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.label(AppString.enterConfirmPassword),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.textField(
                        AppString.enterConfirmPassword,
                        confirmpasswordController,
                        isPassword: true,
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? AppString.confirmPasswordWarning
                                    : null,
                      ),
                      AppWidgets.heightBox(AppSizes.padding40),
                      AuthWidgets.submitButton(
                        text: AppString.createAccount,
                        onPressed: () {
                          if (_userSignUpFormKey.currentState!.validate()) {
                            if (passwordController.text !=
                                confirmpasswordController.text) {
                              AppWidgets.showSnackbar(
                                context,
                                message: AppString.passwordMatchWarning,
                              );
                              return;
                            }
                            authBloc.add(
                              UserSignupEvent(
                                {
                                  "firstname": firstNameController.text,
                                  "lastname": lastNameControlller.text,
                                },
                                emailController.text,
                                confirmpasswordController.text,
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
                            AppString.alreadyHaveAccount,
                            style: TextStyle(fontSize: AppSizes.fontSmall),
                          ),
                          AppWidgets.widthBox(AppSizes.padding10 * 0.5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.userLoginScreen,
                              );
                            },
                            child: Text(
                              AppString.loginHere,
                              style: TextStyle(
                                color: AppColors.bluishGrey,
                                fontSize: AppSizes.fontSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
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
