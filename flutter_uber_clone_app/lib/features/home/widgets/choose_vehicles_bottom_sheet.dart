import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/models/vehicle_fare_model.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/search_captain_bottom_sheet.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_strings.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/app_widgets.dart';
import '../bloc/home_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseVehiclesBottomSheet extends StatefulWidget {
  final Map<String, dynamic> points;

  const ChooseVehiclesBottomSheet({super.key, required this.points});

  @override
  State<ChooseVehiclesBottomSheet> createState() =>
      _ChooseVehiclesBottomSheetState();
}

class _ChooseVehiclesBottomSheetState extends State<ChooseVehiclesBottomSheet> {
  static String vehicleImage(String vehicleType) {
    if (vehicleType == 'auto') {
      return AppAssets.autoImg;
    } else if (vehicleType == 'car') {
      return AppAssets.carImg;
    } else {
      return AppAssets.bikeImg;
    }
  }

  static String vehicleCapacity(String vehicleType) {
    if (vehicleType == 'auto') {
      return '3';
    } else if (vehicleType == 'car') {
      return '4';
    } else {
      return '2';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionableState,
      buildWhen: (previous, current) => current is! HomeActionableState,
      listener: (context, state) {
        if (state is OpenSearchCaptainBottomSheetState) {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            isScrollControlled: true,
            builder: (context) {
              return BlocProvider.value(
                value: context.read<HomeBloc>(),
                child: SearchCaptainBottomSheet(
                  points: widget.points,
                  fare: state.vehicleFare,
                  distanceDuration: state.distanceDuration,
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        if (state is MapDistanceDurationListLoadedState) {
          final vehicleFares = state.vehicleFare;
          return DraggableScrollableSheet(
            initialChildSize: 0.65,
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
                child: Column(
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
                          AppLocalizations.of(context)!.chooseAVehicle,
                          style: TextStyle(
                            fontSize: AppSizes.fontXL,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: vehicleFares.length,
                          itemBuilder: (context, index) {
                            final vehicle = vehicleFares[index];
                            return InkWell(
                              onTap: () {
                                BlocProvider.of<HomeBloc>(context).add(
                                  SelectedVehicleIndexEvent(
                                    vehicleFares,
                                    state.distance,
                                    state.duration,
                                    index,
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                elevation:
                                    index == state.selectedVehicleIndex
                                        ? 10 // Selected color
                                        : 2,
                                surfaceTintColor:
                                    index == state.selectedVehicleIndex
                                        ? Colors
                                            .grey // Selected color
                                        : AppColors.white,
                                color: AppColors.white,
                                // Default color
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Image.asset(
                                            vehicleImage(vehicle.type),
                                            height: 60,
                                            width: 60,
                                          ),
                                          Text(
                                            '2 mins',
                                            style: TextStyle(
                                              fontSize: AppSizes.fontSmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                vehicle.type.toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(
                                                Icons.person,
                                                size: 16,
                                              ),
                                              Text(
                                                vehicleCapacity(vehicle.type),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.route, size: 16),
                                              SizedBox(width: 4),
                                              Text(
                                                state.distance,
                                                style: TextStyle(
                                                  fontSize: AppSizes.fontSmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time_rounded,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                state.duration,
                                                style: TextStyle(
                                                  fontSize: AppSizes.fontSmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.affordableCompactRides,
                                            style: TextStyle(
                                              fontSize: AppSizes.fontSmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '₹${vehicle.amount}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    AppWidgets.heightBox(AppSizes.padding10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.padding20,
                      ),
                      child: InkWell(
                        onTap: () {
                          BlocProvider.of<HomeBloc>(context).add(
                            OpenSearchCaptainBottomSheetEvent(
                              [vehicleFares[state.selectedVehicleIndex]],
                              {
                                "distance": state.distance,
                                "duration": state.duration,
                              },
                            ),
                          );
                          AppLogger.d(
                            widget.points['pickup'] +
                                widget.points['destination'] +
                                vehicleFares[state.selectedVehicleIndex].type,
                          );
                          BlocProvider.of<HomeBloc>(context).add(
                            RideCreatedEvent(
                              widget.points['pickup'],
                              widget.points['destination'],
                              vehicleFares[state.selectedVehicleIndex].type,
                            ),
                          );
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
                              '${AppLocalizations.of(context)!.bookA} ${vehicleFares[state.selectedVehicleIndex].type.toUpperCase()}',
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
        } else {
          return Center(
            child: Text(AppLocalizations.of(context)!.noFareFetched),
          );
        }
      },
    );
  }
}
