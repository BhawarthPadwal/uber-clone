import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/app_widgets.dart';
import '../bloc/home_bloc.dart';

class RideCreatedWidget extends StatefulWidget {
  const RideCreatedWidget({super.key});

  @override
  State<RideCreatedWidget> createState() => _RideCreatedWidgetState();
}

class _RideCreatedWidgetState extends State<RideCreatedWidget> {
  @override
  Widget build(BuildContext context) {
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
                            Text("Captain Name", style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w500)),
                            Text("MH 02 PP 2227", style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w900)),
                            Text("Hyundai i10", style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w500)),
                            AppWidgets.heightBox(5),
                            Text("OTP: 785632", style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold)),
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
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.black),
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
                  Divider(),
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
                  Divider(),
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
