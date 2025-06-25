import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
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
                      AuthWidgets.label("What's your name"),
                      AppWidgets.heightBox(AppSizes.padding10),
                      Row(
                        children: [
                          Expanded(
                            child: AuthWidgets.textField(
                              "First name",
                              firstNameController,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? 'Enter your firstname'
                                          : null,
                            ),
                          ),
                          AppWidgets.widthBox(AppSizes.padding20),
                          Expanded(
                            child: AuthWidgets.textField(
                              "Last name (Optional)",
                              lastNameControlller,
                            ),
                          ),
                        ],
                      ),
                      AppWidgets.heightBox(AppSizes.padding10),
                      AuthWidgets.label("What's your email"),
                      AppWidgets.heightBox(AppSizes.padding10),
                      AuthWidgets.textField(
                        "email@example.com",
                        emailController,
                        isEmail: true,
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Enter your email'
                                    : null,
                      ),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.label("Enter Password"),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.textField(
                        "Password",
                        passwordController,
                        isPassword: true,
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Enter your password'
                                    : null,
                      ),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.label("Confirm Password"),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.textField(
                        "Confirm Password",
                        confirmpasswordController,
                        isPassword: true,
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Confirm your password'
                                    : null,
                      ),
                      AppWidgets.heightBox(AppSizes.padding40),
                      AuthWidgets.submitButton(
                        text: "Create account",
                        onPressed: () {
                          if (_userSignUpFormKey.currentState!.validate()) {
                            if (passwordController.text !=
                                confirmpasswordController.text) {
                              AppWidgets.showSnackbar(
                                context,
                                message: 'Passwords do not match',
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
                            AppWidgets.showSnackbar(context, message: 'Kindly fill all fields');
                          }
                        },
                      ),
                      AppWidgets.heightBox(AppSizes.padding10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have a account?',
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
                              'Login here',
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
