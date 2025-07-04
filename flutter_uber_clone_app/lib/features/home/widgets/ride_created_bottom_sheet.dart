import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/services/socket_service.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/app_widgets.dart';
import '../bloc/home_bloc.dart';
import '../models/vehicle_fare_model.dart';

class RideCreatedWidget extends StatefulWidget { // Data should be fetch from api instead of widgets... api call done
  final Map<String, dynamic> rideData;
  const RideCreatedWidget({super.key, required this.rideData});

  @override
  State<RideCreatedWidget> createState() => _RideCreatedWidgetState();
}

class _RideCreatedWidgetState extends State<RideCreatedWidget> {

  late SocketService socketService;

  void listenToRideStarted() {
    socketService.socket.on('ride-started', (data) {
      AppLogger.i('Ride Started: $data');
      // Handle ride started event
    });
  }
    void listenToRideEnded() {
    socketService.socket.on('ride-ended', (data) {
      AppLogger.i('Ride Ended: $data');
      // Handle ride started event
    });
  }

  @override
  void initState() {
    socketService = SocketService();
    super.initState();
    listenToRideStarted();
    listenToRideEnded();
  }

  @override
  Widget build(BuildContext context) {
    final rideData = widget.rideData;
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionableState,
      buildWhen: (previous, current) => current is! HomeActionableState,
      listener: (context, state) {
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.55,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                children: [
                  AppWidgets.heightBox(AppSizes.padding10),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  AppWidgets.heightBox(AppSizes.padding20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Image.asset(AppAssets.carImg, height: 100, width: 100),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${rideData['captain']['fullname']['firstname']} ${rideData['captain']['fullname']['lastname']}', style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w500)),
                            Text(rideData['captain']['vehicle']['plate'], style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w900)),
                            Text(rideData['captain']['vehicle']['vehicleType'] == 'car' ? "Hyundai i10" : 'Hero Splender' , style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w500)),
                            AppWidgets.heightBox(5),
                            Text(rideData['otp'], style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                  AppWidgets.heightBox(AppSizes.padding10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset(AppAssets.pinIcon, height: 30),
                        AppWidgets.widthBox(AppSizes.padding10),
                        Expanded(
                          child: Text(
                            rideData['pickup'] ?? '',
                            style: TextStyle(
                              fontSize: AppSizes.fontMedium,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.black),
                        AppWidgets.widthBox(AppSizes.padding10),
                        Expanded(
                          child: Text(
                            rideData['destination'] ?? '',
                            style: TextStyle(
                              fontSize: AppSizes.fontMedium,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.credit_card_sharp, color: AppColors.black),
                        AppWidgets.widthBox(AppSizes.padding10),
                        Text(
                          '₹ ${rideData['fare']}',
                          style: TextStyle(
                            fontSize: AppSizes.fontMedium,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppWidgets.heightBox(AppSizes.padding20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding20,
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigator.of(context).pop();
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
                            'Make Payment',
                            style: TextStyle(
                              fontSize: AppSizes.fontMedium,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppWidgets.heightBox(AppSizes.padding20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
