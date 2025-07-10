/// RideCreatedWidget
/// ------------------
/// This widget displays a ride detail screen inside a DraggableScrollableSheet.
/// It integrates Google Maps, live route polyline, vehicle info, and a payment button.
/// It also listens to ride status events (started/ended) via socket.

import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/home_widgets.dart';
import 'package:flutter_uber_clone_app/services/api_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_strings.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../services/socket_service.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/logger/app_logger.dart';
import '../bloc/home_bloc.dart';

class RideCreatedWidget extends StatefulWidget {
  final Map<String, dynamic> rideData;

  const RideCreatedWidget({super.key, required this.rideData});

  @override
  State<RideCreatedWidget> createState() => _RideCreatedWidgetState();
}

class _RideCreatedWidgetState extends State<RideCreatedWidget> {
  final socketService = SocketService();
  bool _isMounted = true;
  String currentStatus = AppString.waitingForConfirmation;
  bool _isMapReady = false;
  late String _pickupLocation;
  late String _destinationLocation;
  late LatLng _pickupLatLng;
  late LatLng _destinationLatLng;
  late PolylinePoints polylinePoints;
  final Completer<GoogleMapController> _mapController = Completer();
  String? polylineStringData;
  List<PointLatLng> decodedPoints = [];

  void listenToRideStarted() {
    socketService.socket.on('ride-started', (data) {
      if (!_isMounted || !mounted) return;

      AppLogger.i('Ride Started: \n $data');
      BlocProvider.of<HomeBloc>(
        context,
      ).add(UpdateCurrentStateToRideStartedEvent());
    });
  }

  void listenToRideEnded() {
    socketService.socket.on('ride-ended', (data) {
      if (!_isMounted || !mounted) return;

      AppLogger.i('Ride Ended: \n $data');
      BlocProvider.of<HomeBloc>(
        context,
      ).add(UpdateCurrentStateToRideEndedEvent());
    });
  }

  /// Adjusts camera to fit both pickup and destination markers
  void _moveCameraToFitBounds() async {
    final GoogleMapController controller = await _mapController.future;
    LatLngBounds bounds;
    if (_pickupLatLng.latitude > _destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: _destinationLatLng,
        northeast: _pickupLatLng,
      );
    } else {
      bounds = LatLngBounds(
        southwest: _pickupLatLng,
        northeast: _destinationLatLng,
      );
    }

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  /// Converts pickup and destination addresses to coordinates
  Future<void> _convertAddressesToCoordinates() async {
    try {
      final pickupLocations = await locationFromAddress(_pickupLocation);
      final destinationLocations = await locationFromAddress(
        _destinationLocation,
      );

      if (pickupLocations.isNotEmpty && destinationLocations.isNotEmpty) {
        setState(() {
          _pickupLatLng = LatLng(
            pickupLocations.first.latitude,
            pickupLocations.first.longitude,
          );
          _destinationLatLng = LatLng(
            destinationLocations.first.latitude,
            destinationLocations.first.longitude,
          );
          _isMapReady = true;
        });
      }
    } catch (e) {
      AppLogger.e("Error converting address to coordinates: \$e");
    }
  }

  /// Fetches route polyline from backend and decodes it
  Future<void> fetchRoutePolyline() async {
    try {
      polylineStringData = await ApiService.getRoutes(
        _pickupLocation,
        _destinationLocation,
      );
      AppLogger.d("Polyline String: \$polylineStringData");

      if (polylineStringData != null) {
        decodedPoints = polylinePoints.decodePolyline(polylineStringData!);
        AppLogger.d(decodedPoints);
      }

      if (mounted) setState(() {});
    } catch (e) {
      AppLogger.e("Failed to fetch polyline: \$e");
    }
  }

  /// Converts list of PointLatLng to LatLng
  List<LatLng> convertToLatLng(List<PointLatLng> points) {
    return points.map((p) => LatLng(p.latitude, p.longitude)).toList();
  }

  @override
  void initState() {
    super.initState();
    // socketService = SocketService();
    listenToRideStarted();
    listenToRideEnded();

    final rideData = widget.rideData;
    _pickupLocation = rideData['pickup'];
    _destinationLocation = rideData['destination'];

    polylinePoints = PolylinePoints();
    _convertAddressesToCoordinates();
    fetchRoutePolyline();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _moveCameraToFitBounds(),
    );
  }

  @override
  void dispose() {
    _isMounted = false;
    socketService.socket.off('ride-started');
    socketService.socket.off('ride-ended');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideData = widget.rideData;

    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionableState,
      buildWhen: (previous, current) => current is! HomeActionableState,
      listener: (context, state) {
        if (state is MakePaymentSuccessState) {
          AppLogger.i('Payment confirmed, closing sheet...');
          Navigator.pop(context);
        }
        if (state is UpdateCurrentStateToRideStartedState) {
          setState(() => currentStatus = AppString.rideStarted);
        } else if (state is UpdateCurrentStateToRideEndedState) {
          setState(() => currentStatus = AppString.makePayment);
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.95,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  lottie.Lottie.asset(
                    AppAssets.driverFoundAnim,
                    height: 200,
                    width: 200,
                  ),

                  /// Map Preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 250,
                      child:
                          _isMapReady
                              ? GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: _pickupLatLng,
                                  zoom: 14,
                                ),
                                onMapCreated:
                                    (controller) =>
                                        _mapController.complete(controller),
                                markers: {
                                  Marker(
                                    markerId: MarkerId("pickup"),
                                    position: _pickupLatLng,
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueGreen,
                                    ),
                                  ),
                                  Marker(
                                    markerId: MarkerId("destination"),
                                    position: _destinationLatLng,
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueRed,
                                    ),
                                  ),
                                },
                                polylines: {
                                  Polyline(
                                    polylineId: PolylineId("route"),
                                    points: convertToLatLng(decodedPoints),
                                    color: Colors.blueAccent,
                                    width: 5,
                                    jointType: JointType.round,
                                    startCap: Cap.roundCap,
                                    endCap: Cap.roundCap,
                                    geodesic: true,
                                  ),
                                },
                                myLocationButtonEnabled: true,
                                myLocationEnabled: true,
                                scrollGesturesEnabled: true,
                                zoomGesturesEnabled: true,
                                mapType: MapType.normal,
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                              )
                              : const Center(
                                child: CircularProgressIndicator(),
                              ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Captain Info Card
                  _buildCaptainInfoCard(rideData),

                  const SizedBox(height: 20),

                  /// Pickup and Destination Info
                  HomeWidgets.buildInfoRow(
                    AppAssets.pinIcon,
                    rideData['pickup'] ?? '',
                  ),
                  Divider(indent: 10, endIndent: 10),
                  HomeWidgets.buildInfoRow(
                    Icons.location_on,
                    rideData['destination'] ?? '',
                  ),
                  Divider(indent: 10, endIndent: 10),
                  HomeWidgets.buildInfoRow(
                    Icons.credit_card,
                    '₹ ${rideData['fare']}',
                  ),

                  const SizedBox(height: 40),

                  /// Payment Button
                  _buildPaymentButton(rideData),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Returns widget containing captain and vehicle info
  Widget _buildCaptainInfoCard(Map<String, dynamic> rideData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.carImg, height: 80, width: 80),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${rideData['captain']['fullname']['firstname']} ${rideData['captain']['fullname']['lastname']}',
                  style: TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  rideData['captain']['vehicle']['plate']
                      .toString()
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  rideData['captain']['vehicle']['vehicleType'] == 'car'
                      ? "Hyundai i10"
                      : 'Hero Splendor',
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "OTP: ${rideData['otp']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.fontMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the dynamic payment button based on currentStatus
  Widget _buildPaymentButton(Map<String, dynamic> rideData) {
    return ElevatedButton(
      onPressed:
          currentStatus == AppString.makePayment
              ? () {
                BlocProvider.of<HomeBloc>(
                  context,
                ).add(MakePaymentEvent(rideData['_id']));
              }
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            currentStatus == AppString.makePayment
                ? AppColors.lightGreen
                : AppColors.white,
        foregroundColor:
            currentStatus == AppString.makePayment
                ? AppColors.white
                : AppColors.lightGreen,
        disabledBackgroundColor: Colors.white,
        disabledForegroundColor: AppColors.lightGreen,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.padding10),
          side: BorderSide(color: AppColors.lightGreen, width: 2),
        ),
      ),
      child: Text(
        currentStatus == AppString.waitingForConfirmation
            ? AppLocalizations.of(context)!.waitingForConfirmation
            : currentStatus == AppString.rideStarted
            ? AppLocalizations.of(context)!.rideStarted
            : currentStatus == AppString.makePayment
            ? AppLocalizations.of(context)!.makePayment
            : currentStatus,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.fontMedium,
        ),
      ),

      /*child: Text(
        currentStatus,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.fontMedium,
        ),
      ),*/
    );
  }
}
