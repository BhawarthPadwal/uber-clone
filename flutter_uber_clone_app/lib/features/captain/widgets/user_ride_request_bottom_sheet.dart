import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import 'package:flutter_uber_clone_app/features/captain/bloc/captain_bloc.dart';
import 'package:flutter_uber_clone_app/services/socket_service.dart';
import 'package:flutter_uber_clone_app/services/api_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_assets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_enum.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Bottom sheet widget that shows ride request details to the captain.
/// Allows accepting, confirming, and completing the ride along with payment handling.
class UserRideRequestBottomSheet extends StatefulWidget {
  final Map<String, dynamic> rideRequest;

  const UserRideRequestBottomSheet({super.key, required this.rideRequest});

  @override
  State<UserRideRequestBottomSheet> createState() =>
      _UserRideRequestBottomSheetState();
}

class _UserRideRequestBottomSheetState
    extends State<UserRideRequestBottomSheet> {
  final TextEditingController otpController = TextEditingController();
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  late SocketService socketService;
  late PolylinePoints polylinePoints;

  RideStatus rideStatus = RideStatus.pending;

  bool get isAccepted =>
      rideStatus == RideStatus.accepted || rideStatus == RideStatus.confirmed;

  bool get isOtpConfirmed => rideStatus == RideStatus.confirmed;

  Map<String, dynamic>? paymentStatus;

  bool _isMapReady = false;
  late String _pickupLocation;
  late String _destinationLocation;
  late LatLng _pickupLatLng;
  late LatLng _destinationLatLng;
  final Completer<GoogleMapController> _mapController = Completer();
  String? polylineStringData;
  List<PointLatLng> decodedPoints = [];

  /// Returns the button label based on current [rideStatus].
  String get primaryButtonText {
    switch (rideStatus) {
      case RideStatus.pending:
        return AppLocalizations.of(context)!.accept;
      case RideStatus.accepted:
        return AppLocalizations.of(context)!.confirm;
      case RideStatus.confirmed:
        return AppLocalizations.of(context)!.completedRide;
      case RideStatus.payment_pending:
        return AppLocalizations.of(context)!.paymentPending;
      case RideStatus.paid:
        return AppLocalizations.of(context)!.paymentDone;
    }
  }

  @override
  void initState() {
    super.initState();
    socketService = SocketService();
    listenToPaymentStatus();

    final rideData = widget.rideRequest;
    _pickupLocation = rideData['pickup'];
    _destinationLocation = rideData['destination'];

    polylinePoints = PolylinePoints();
    _convertAddressesToCoordinates();
    fetchRoutePolyline();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _moveCameraToFitBounds(),
    );
  }

  /// Sets up a listener to handle real-time payment confirmation events.
  void listenToPaymentStatus() {
    socketService.socket.on('payment-confirmed', (data) {
      AppLogger.i('Payment Status: $data');

      if (data is Map && data.containsKey('status')) {
        try {
          final castedData = Map<String, dynamic>.from(data);
          if (castedData['status'] == 'paid') {
            if (mounted) {
              setState(() {
                rideStatus = RideStatus.paid;
                paymentStatus = castedData;
              });

              AppLogger.i('Payment confirmed, closing sheet...');
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) Navigator.pop(context);
              });
            }
          }
        } catch (e) {
          AppLogger.e("Error parsing payment-confirmed data: $e");
        }
      }
    });
  }

  /// Converts pickup and destination address strings into LatLng coordinates.
  Future<void> _convertAddressesToCoordinates() async {
    try {
      final pickup = await locationFromAddress(_pickupLocation);
      final destination = await locationFromAddress(_destinationLocation);

      if (pickup.isNotEmpty && destination.isNotEmpty) {
        setState(() {
          _pickupLatLng = LatLng(pickup.first.latitude, pickup.first.longitude);
          _destinationLatLng = LatLng(
            destination.first.latitude,
            destination.first.longitude,
          );
          _isMapReady = true;
        });
      }
    } catch (e) {
      AppLogger.e("Error converting address to coordinates: $e");
    }
  }

  /// Fetches the encoded polyline string from backend and decodes it.
  Future<void> fetchRoutePolyline() async {
    try {
      polylineStringData = await ApiService.getRoutes(
        _pickupLocation,
        _destinationLocation,
      );
      AppLogger.d("Polyline String: $polylineStringData");

      if (polylineStringData != null) {
        decodedPoints = polylinePoints.decodePolyline(polylineStringData!);
        AppLogger.d(decodedPoints);
      }

      if (mounted) setState(() {});
    } catch (e) {
      AppLogger.e("Failed to fetch polyline: $e");
    }
  }

  /// Converts polyline points to [LatLng] format for use with [GoogleMap].
  List<LatLng> convertToLatLng(List<PointLatLng> points) {
    return points.map((p) => LatLng(p.latitude, p.longitude)).toList();
  }

  /// Moves the map camera to fit both pickup and destination markers.
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

  String _getTitleTextForStatus() {
    switch (rideStatus) {
      case RideStatus.pending:
        return AppLocalizations.of(context)!.newRideAvailable;
      case RideStatus.accepted:
        return AppLocalizations.of(context)!.confirmRideToStart;
      case RideStatus.confirmed:
        return AppLocalizations.of(context)!.rideInProgress;
      case RideStatus.payment_pending:
        return AppLocalizations.of(context)!.waitingForPayment;
      case RideStatus.paid:
        return AppLocalizations.of(context)!.rideCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rideRequest = widget.rideRequest;
    AppLogger.d(rideRequest);

    return BlocBuilder<CaptainBloc, CaptainState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          controller: sheetController,
          initialChildSize: 0.95,
          minChildSize: 0.95,
          maxChildSize: 0.95,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppSizes.padding10),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: AppSizes.padding20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.padding20,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          _getTitleTextForStatus(),
                          style: TextStyle(
                            fontSize: AppSizes.fontXL,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.padding20),

                    // User Info and Distance
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.padding20,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isAccepted ? Colors.white : Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isAccepted ? Colors.amber : Colors.white,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: AppColors.lightGrey,
                                child: Icon(Icons.person),
                              ),
                              const SizedBox(width: AppSizes.padding10),
                              Text(
                                '${rideRequest['user']['fullname']['firstname']} '
                                '${rideRequest['user']['fullname']['lastname']}',
                                style: TextStyle(
                                  fontSize: AppSizes.fontMedium,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
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

                    const SizedBox(height: AppSizes.padding20),

                    // Map Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
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
                                        icon:
                                            BitmapDescriptor.defaultMarkerWithHue(
                                              BitmapDescriptor.hueGreen,
                                            ),
                                      ),
                                      Marker(
                                        markerId: MarkerId("destination"),
                                        position: _destinationLatLng,
                                        icon:
                                            BitmapDescriptor.defaultMarkerWithHue(
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
                                    myLocationEnabled: true,
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
                    ),

                    // Ride Info
                    buildInfoRow(AppAssets.pinIcon, rideRequest['pickup']),
                    buildDivider(),
                    buildInfoRow(Icons.location_on, rideRequest['destination']),
                    buildDivider(),
                    buildInfoRow(
                      Icons.credit_card_sharp,
                      '₹${rideRequest['fare']}',
                    ),

                    // OTP Field
                    if (rideStatus == RideStatus.accepted) buildOtpField(),

                    // Waiting for Payment
                    if (rideStatus == RideStatus.payment_pending)
                      buildPaymentWaiting(),

                    // Primary Button
                    buildPrimaryButton(),

                    // Cancel/Ignore Button
                    if (!isOtpConfirmed) buildSecondaryButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildInfoRow(dynamic icon, String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          icon is String
              ? Image.asset(icon, height: 30)
              : Icon(icon, color: AppColors.black, size: 30),
          const SizedBox(width: AppSizes.padding10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppSizes.fontMedium,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() => const Divider(indent: 20, endIndent: 20);

  Widget buildOtpField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding20,
        vertical: AppSizes.padding20,
      ),
      child: TextFormField(
        controller: otpController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.enterOTP,
          contentPadding: const EdgeInsets.all(AppSizes.padding20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          fillColor: AppColors.lightGrey,
          filled: true,
        ),
      ),
    );
  }

  Widget buildPaymentWaiting() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 12),
          Text(AppLocalizations.of(context)!.waitingForPaymentConfirmation),
        ],
      ),
    );
  }

  Widget buildPrimaryButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding20),
      child: InkWell(
        onTap: handlePrimaryButtonTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(AppSizes.padding10),
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
    );
  }

  Widget buildSecondaryButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding20,
        vertical: AppSizes.padding10,
      ),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isAccepted ? Colors.red : AppColors.bluishGrey,
            borderRadius: BorderRadius.circular(AppSizes.padding10),
          ),
          child: Center(
            child: Text(
              isAccepted
                  ? AppLocalizations.of(context)!.cancel
                  : AppLocalizations.of(context)!.ignore,
              style: TextStyle(
                fontSize: AppSizes.fontMedium,
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles tap on the main action button according to ride status.
  void handlePrimaryButtonTap() {
    setState(() {
      switch (rideStatus) {
        case RideStatus.pending:
          BlocProvider.of<CaptainBloc>(
            context,
          ).add(AcceptRideEvent(widget.rideRequest['_id']));
          rideStatus = RideStatus.accepted;
          break;

        case RideStatus.accepted:
          if (otpController.text.trim().isEmpty) {
            AppWidgets.showSnackbar(
              context,
              message: AppLocalizations.of(context)!.pleaseEnterOTP,
            );
            return;
          }
          BlocProvider.of<CaptainBloc>(context).add(
            StartRideEvent(
              widget.rideRequest['_id'],
              otpController.text.trim(),
            ),
          );
          otpController.clear();
          rideStatus = RideStatus.confirmed;
          break;

        case RideStatus.confirmed:
          BlocProvider.of<CaptainBloc>(
            context,
          ).add(EndRideEvent(widget.rideRequest['_id']));
          AppWidgets.showSnackbar(
            context,
            message: AppLocalizations.of(context)!.rideCompleted,
          );
          rideStatus = RideStatus.payment_pending;
          break;

        case RideStatus.payment_pending:
          if (paymentStatus?['status'] == 'paid') {
            rideStatus = RideStatus.paid;
          }
          break;

        case RideStatus.paid:
          Navigator.pop(context);
          break;
      }
    });
  }
}
