import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _userLoginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                Text(
                  'Uber',
                  style: TextStyle(
                    fontSize: AppSizes.fontXXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 40),
                AuthWidgets.label("What's your email"),
                SizedBox(height: AppSizes.paddingM),
                AuthWidgets.textField(
                  hintText: "email@example.com",
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
                    if (_userLoginFormKey.currentState!.validate()) {
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
                    Text('New here?'),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.userSignupScreen,
                        );
                      },
                      child: Text(
                        'Create new Account',
                        style: TextStyle(color: AppColors.bluishGrey),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                AuthWidgets.submitButton(
                  text: "Sign in as Captain",
                  backgroundColor: AppColors.lightGreen,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.captainLoginScreen,
                    );
                  },
                ),
                SizedBox(height: AppSizes.padding20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
