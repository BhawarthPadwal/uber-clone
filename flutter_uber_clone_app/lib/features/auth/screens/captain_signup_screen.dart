import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';

class CaptainSignupScreen extends StatefulWidget {
  const CaptainSignupScreen({super.key});

  @override
  State<CaptainSignupScreen> createState() => _CaptainSignupScreenState();
}

class _CaptainSignupScreenState extends State<CaptainSignupScreen> {
  String? selectedVehicle;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uber',
                  style: TextStyle(
                    fontSize: AppSizes.fontXXL,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.arrow_forward, size: 40),
                SizedBox(height: 40),
                Text(
                  "What's our Captain's name",
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                            border: InputBorder.none,
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
                  "What's our Captain's email",
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
                SizedBox(height: 30),
                Text(
                  "Vehicle Information",
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
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
                            hintText: "Vehicle Color",
                            border: InputBorder.none,
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
                            hintText: "Vehicle Plate",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(AppSizes.paddingM),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                            hintText: "Vehicle capacity",
                            border: InputBorder.none,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedVehicle,
                          icon: const Icon(Icons.arrow_drop_down),
                          dropdownColor: AppColors.white,
                          style: TextStyle(
                            fontSize: AppSizes.fontMedium,
                            color: AppColors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none, // No underline
                          ),
                          hint: Text(
                            "Select vehicle",
                            style: TextStyle(fontSize: AppSizes.fontMedium),
                          ),
                          items:
                              ['Car', 'Bike', 'Auto'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedVehicle = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.paddingM),
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
    );
  }
}
