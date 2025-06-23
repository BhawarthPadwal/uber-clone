import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';

class CaptainLoginScreen extends StatefulWidget {
  const CaptainLoginScreen({super.key});

  @override
  State<CaptainLoginScreen> createState() => _CaptainLoginScreenState();
}

class _CaptainLoginScreenState extends State<CaptainLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _captainLoginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    'Uber',
                    style: TextStyle(
                      fontSize: AppSizes.fontXXL,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.arrow_forward, size: 40),
                  SizedBox(height: 40),
                  AuthWidgets.label("What's your email"),
                  SizedBox(height: AppSizes.paddingM),
                  AuthWidgets.textField(
                    hintText: "email@example.com",
                    isPassword: false,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  AuthWidgets.label("Enter Password"),
                  SizedBox(height: AppSizes.paddingM),
                  AuthWidgets.textField(
                    hintText: "password",
                    isPassword: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  AuthWidgets.submitButton(
                    text: "Login",
                    onPressed: () {
                      if (_captainLoginFormKey.currentState!.validate()) {
                        debugPrint('Form valid ✅');
                      } else {
                        debugPrint('Validation failed ❌');
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Join a fleet?'),
                      SizedBox(width: 5),
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
                            style: TextStyle(color: AppColors.bluishGrey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 250),
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
                  SizedBox(height: AppSizes.padding20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
