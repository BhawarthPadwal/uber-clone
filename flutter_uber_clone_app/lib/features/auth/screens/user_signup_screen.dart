import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';

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
  final _userSignUpFormKey = GlobalKey<FormState>();

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
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _userSignUpFormKey,
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
                  AuthWidgets.label("What's your name"),
                  SizedBox(height: AppSizes.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          ),
                          child: TextFormField(
                            style: TextStyle(fontSize: AppSizes.fontMedium),
                            decoration: InputDecoration(
                              hintText: "First name",
                              border
                              : InputBorder.none,
                              contentPadding: EdgeInsets.all(AppSizes.paddingM),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          ),
                          child: TextFormField(
                            style: TextStyle(fontSize: AppSizes.fontMedium),
                            decoration: InputDecoration(
                              hintText: "Last name",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(AppSizes.paddingM),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.paddingM),
                  Text(
                    "What's your email",
                    style: TextStyle(
                      fontSize: AppSizes.fontMedium,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingM),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize: AppSizes.fontMedium),
                      decoration: InputDecoration(
                        hintText: "email@example.com",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(AppSizes.paddingM),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Enter Password",
                    style: TextStyle(
                      fontSize: AppSizes.fontMedium,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingM),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize: AppSizes.fontMedium),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "password",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(AppSizes.paddingM),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
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
                        'Create account',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have a account?'),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.userLoginScreen,
                          );
                        },
                        child: Text(
                          'Login here',
                          style: TextStyle(color: AppColors.bluishGrey),
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
  }
}
