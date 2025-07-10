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
  AuthBloc authBloc = AuthBloc();

  @override
  void dispose() {
    firstNameTextEditingController.dispose();
    lastNameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordController.dispose();
    vehicleColorTextEditingController.dispose();
    vehiclePlateTextEditingController.dispose();
    vehicleCapacityTextEditingController.dispose();
    authBloc.close();
    super.dispose();
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
                      AuthWidgets.label(AppString.captainNameLabel),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      Row(
                        children: [
                          Expanded(
                            child: AuthWidgets.textField(
                              AppString.firstNameLabel,
                              firstNameTextEditingController,
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
                              lastNameTextEditingController,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? AppString.lastNameWarning
                                          : null,
                            ),
                          ),
                        ],
                      ),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.label(AppString.captainEmailLabel),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.textField(
                        isEmail: true,
                        AppString.emailHint,
                        emailTextEditingController,
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
                        passwordTextEditingController,
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
                        confirmPasswordController,
                        isPassword: true,
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? AppString.confirmPasswordWarning
                                    : null,
                      ),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      AuthWidgets.label(AppString.vehicleInfoLabel),
                      AppWidgets.heightBox(AppSizes.paddingM),
                      Row(
                        children: [
                          Expanded(
                            child: AuthWidgets.textField(
                              AppString.vehicleInfoLabel,
                              vehicleColorTextEditingController,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? AppString.vehicleColorWarning
                                          : null,
                            ),
                          ),
                          AppWidgets.widthBox(AppSizes.padding20),
                          Expanded(
                            child: AuthWidgets.textField(
                              AppString.vehiclePlateLabel,
                              vehiclePlateTextEditingController,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? AppString.vehiclePlateWarning
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
                              AppString.vehicleCapacityLabel,
                              vehicleCapacityTextEditingController,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? AppString.vehicleCapacityWarning
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
                                  AppString.selectVehicleTypeLabel,
                                  style: TextStyle(
                                    fontSize: AppSizes.fontSmall,
                                    color: Colors.black54,
                                  ),
                                ),
                                items:
                                    [
                                      AppString.carLabel,
                                      AppString.motorcycleLabel,
                                      AppString.autoLabel,
                                    ].map((String value) {
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
                                            ? AppString.vehicleTypeWarning
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
                        text: AppString.createAccount,
                        onPressed: () {
                          if (_captainSignUpFormKey.currentState!.validate()) {
                            if (passwordTextEditingController.text !=
                                confirmPasswordController.text) {
                              AppWidgets.showSnackbar(
                                context,
                                message: AppString.passwordMatchWarning,
                              );
                              return;
                            }
                            authBloc.add(
                              CaptainSignupEvent(
                                {
                                  "firstname":
                                      firstNameTextEditingController.text,
                                  "lastname":
                                      lastNameTextEditingController.text ?? "",
                                },
                                emailTextEditingController.text,
                                confirmPasswordController.text,
                                {
                                  "color":
                                      vehicleColorTextEditingController.text,
                                  "plate":
                                      vehiclePlateTextEditingController.text,
                                  "capacity":
                                      vehicleCapacityTextEditingController.text,
                                  "vehicleType": selectedVehicle,
                                },
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
                          AppWidgets.widthBox(AppSizes.padding10 * 0.2),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.captainLoginScreen,
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
