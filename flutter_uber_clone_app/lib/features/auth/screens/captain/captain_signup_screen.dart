import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';

class CaptainSignupScreen extends StatefulWidget {
  const CaptainSignupScreen({super.key});

  @override
  State<CaptainSignupScreen> createState() => _CaptainSignupScreenState();
}

class _CaptainSignupScreenState extends State<CaptainSignupScreen> {
  final _captainSignUpFormKey = GlobalKey<FormState>();
  TextEditingController firstNameTextEditingController =
      TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController vehicleColorTextEditingController =
      TextEditingController();
  TextEditingController vehiclePlateTextEditingController =
      TextEditingController();
  TextEditingController vehicleCapacityTextEditingController =
      TextEditingController();
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
            child: Form(
              key: _captainSignUpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthWidgets.uberLabel(),
                  Icon(Icons.arrow_forward, size: AppSizes.padding30),
                  AppWidgets.heightBox(AppSizes.padding20),
                  AuthWidgets.label("What's our Captain's name"),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: AuthWidgets.textField(
                          "First name",
                          firstNameTextEditingController,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Enter your firstname'
                                      : null,
                        ),
                      ),
                      AppWidgets.widthBox(AppSizes.padding20),
                      Expanded(
                        child: AuthWidgets.textField(
                          "Last name (Optional)",
                          lastNameTextEditingController,
                        ),
                      ),
                    ],
                  ),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  AuthWidgets.label("What's our Captain's email"),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  AuthWidgets.textField(
                    isEmail: true,
                    "email@example.com",
                    emailTextEditingController,
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? 'Enter your email'
                                : null,
                  ),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  AuthWidgets.label("Enter Password"),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  AuthWidgets.textField(
                    "Password",
                    passwordTextEditingController,
                    isPassword: true,
                    validator: (value) =>
                            (value == null || value.isEmpty)
                                ? 'Enter your password'
                                : null,
                  ),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  AuthWidgets.label("Confirm Password"),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  AuthWidgets.textField(
                    "Confirm Password",
                    confirmPasswordController,
                    isPassword: true,
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? 'Confirm your password'
                        : null,
                  ),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  AuthWidgets.label("Vehicle Information"),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: AuthWidgets.textField(
                          "Vehicle Color",
                          vehicleColorTextEditingController,
                          validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Enter vehicle color'
                                      : null,
                        ),
                      ),
                      AppWidgets.widthBox(AppSizes.padding20),
                      Expanded(
                        child: AuthWidgets.textField(
                          "Vehicle Plate",
                          vehiclePlateTextEditingController,
                          validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Enter vehicle plate'
                                      : null,
                        ),
                      ),
                    ],
                  ),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: AuthWidgets.textField(
                          "Vehicle Capacity",
                          vehicleColorTextEditingController,
                          validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Enter vehicle capacity'
                                      : null,
                        ),
                      ),
                      AppWidgets.widthBox(AppSizes.padding20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.lightGrey,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppSizes.paddingM,
                                vertical: AppSizes.paddingS,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              errorStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                height: 1.2,
                              ),
                            ),
                            hint: Text(
                              "Select vehicle",
                              style: TextStyle(
                                fontSize: AppSizes.fontSmall,
                                color: Colors.black54,
                              ),
                            ),
                            items:
                                ['Car', 'Bike', 'Auto'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: AppSizes.fontSmall,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedVehicle = newValue;
                              });
                            },
                            validator:
                                (value) =>
                                    (value == null || value.isEmpty)
                                        ? 'Enter vehicle type'
                                        : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppWidgets.heightBox(AppSizes.paddingM),
                  AuthWidgets.submitButton(
                    text: "Create account",
                    onPressed: () {
                      if (_captainSignUpFormKey.currentState!.validate()) {
                        debugPrint('Form valid');
                      } else {
                        debugPrint('Validation failed');
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
                      AppWidgets.widthBox(AppSizes.padding10 * 0.2),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.captainLoginScreen,
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
  }
}
