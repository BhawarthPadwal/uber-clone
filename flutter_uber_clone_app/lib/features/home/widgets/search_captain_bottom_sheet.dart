import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/bloc/home_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/models/vehicle_fare_model.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/ride_created_bottom_sheet.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_assets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/app_sizes.dart';

class SearchCaptainBottomSheet extends StatefulWidget {
  final Map<String, dynamic> points;
  final List<VehicleFare> fare;
  final Map<String, dynamic> distanceDuration;
  const SearchCaptainBottomSheet({super.key, required this.points, required this.fare, required this.distanceDuration});

  @override
  State<SearchCaptainBottomSheet> createState() =>
      _SearchCaptainBottomSheetState();
}

class _SearchCaptainBottomSheetState extends State<SearchCaptainBottomSheet> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(minutes: 5), () {
      // BlocProvider.of<HomeBloc>(context).add(RideCreatedEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionableState,
      buildWhen: (previous, current) => current is! HomeActionableState,
      listener: (context, state) {
            if (state is RideCreatedState) {
          Navigator.of(context).pop();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            builder:
                (context) => BlocProvider.value(
                  value: context.read<HomeBloc>(),
                  child: RideCreatedWidget(points: widget.points, fare: widget.fare, distanceDuration: widget.distanceDuration),
                ),
          );
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.65,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding20,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Looking for nearby drivers',
                      style: TextStyle(
                        fontSize: AppSizes.fontXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  AppWidgets.heightBox(AppSizes.padding20),
                  LinearProgressIndicator(
                    color: AppColors.black,
                    backgroundColor: AppColors.lightGrey,
                    minHeight: 2,
                  ),
                  AppWidgets.heightBox(AppSizes.padding10),
                  Lottie.asset(
                    AppAssets.searchDriverAnim,
                    height: 200,
                    width: 200,
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
                            widget.points['pickup'],
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
                            widget.points['destination'],
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
                          '₹ ${widget.fare[0].amount.toString()}',
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
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppSizes.padding10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel Ride',
                            style: TextStyle(
                              fontSize: AppSizes.fontMedium,
                              color: AppColors.white,
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
