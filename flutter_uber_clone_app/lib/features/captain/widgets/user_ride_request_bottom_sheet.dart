import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_assets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_enum.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';

class UserRideRequestBottomSheet extends StatefulWidget {
  const UserRideRequestBottomSheet({super.key});

  @override
  State<UserRideRequestBottomSheet> createState() =>
      _UserRideRequestBottomSheetState();
}

class _UserRideRequestBottomSheetState
    extends State<UserRideRequestBottomSheet> {
  TextEditingController otpController = TextEditingController();
  final DraggableScrollableController sheetController =
  DraggableScrollableController();

  /*bool isAccepted = false;
  bool isOtpConfirmed = false;*/
  RideStatus rideStatus = RideStatus.pending;

  bool get isAccepted =>
      rideStatus == RideStatus.accepted || rideStatus == RideStatus.confirmed;

  bool get isOtpConfirmed => rideStatus == RideStatus.confirmed;

  String get primaryButtonText {
    switch (rideStatus) {
      case RideStatus.pending:
        return 'Accept';
      case RideStatus.accepted:
        return 'Confirm';
      case RideStatus.confirmed:
        return 'Completed Ride';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: sheetController,
      initialChildSize: rideStatus == RideStatus.accepted ? 0.75 : 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppWidgets.heightBox(AppSizes.padding10),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AppWidgets.heightBox(AppSizes.padding20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.padding20,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      isAccepted
                          ? 'Confirm Ride to Start!'
                          : 'New Ride Available!',
                      style: TextStyle(
                        fontSize: AppSizes.fontXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                AppWidgets.heightBox(AppSizes.padding20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.padding20,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isAccepted ? Colors.white : Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isAccepted ? Colors.amber : Colors.white,
                        // or any colors
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(Icons.person),
                          ),
                          AppWidgets.widthBox(AppSizes.padding10),
                          Text(
                            "Rahul Charles",
                            style: TextStyle(
                              fontSize: AppSizes.fontMedium,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "2.2 km",
                            style: TextStyle(
                              fontSize: AppSizes.fontLarge,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppWidgets.heightBox(AppSizes.padding20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.asset(AppAssets.pinIcon, height: 30),
                      AppWidgets.widthBox(AppSizes.padding10),
                      Text(
                        'Current Location',
                        style: TextStyle(
                          fontSize: AppSizes.fontMedium,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(indent: 20, endIndent: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.black, size: 30),
                      AppWidgets.widthBox(AppSizes.padding10),
                      Text(
                        'Destination Location',
                        style: TextStyle(
                          fontSize: AppSizes.fontMedium,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(indent: 20, endIndent: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.credit_card_sharp, color: AppColors.black),
                      AppWidgets.widthBox(AppSizes.padding10),
                      Text(
                        '₹ 101',
                        style: TextStyle(
                          fontSize: AppSizes.fontMedium,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: rideStatus == RideStatus.accepted,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding20,
                      vertical: AppSizes.padding20,
                    ),
                    child: TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(
                        hintText: "Enter OTP",
                        contentPadding: EdgeInsets.all(AppSizes.padding20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: AppColors.lightGrey,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isOtpConfirmed,
                  child: SizedBox(height: AppSizes.padding50),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.padding20,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        switch (rideStatus) {
                          case RideStatus.pending:
                            // Accept the ride
                            rideStatus = RideStatus.accepted;
                            break;

                          case RideStatus.accepted:
                            // Confirm OTP
                            if (otpController.text.trim().isEmpty) {
                              AppWidgets.showSnackbar(
                                context,
                                message: 'Please enter OTP',
                              );
                              AppLogger.i('Please enter OTP');
                              return;
                            }
                            rideStatus = RideStatus.confirmed;
                            break;

                          case RideStatus.confirmed:
                            // Ride complete
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              AppWidgets.showSnackbar(
                                context,
                                message: 'Ride Completed',
                              );
                            });
                            AppLogger.i('Ride Completed');
                            break;
                        }
                      });
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppSizes.padding10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          primaryButtonText,
                          style: TextStyle(
                            fontSize: AppSizes.fontMedium,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (isOtpConfirmed) ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding20,
                      vertical: AppSizes.padding10,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: isAccepted ? Colors.red : AppColors.bluishGrey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppSizes.padding10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isAccepted ? 'Cancel' : 'Ignore',
                            style: TextStyle(
                              fontSize: AppSizes.fontMedium,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
