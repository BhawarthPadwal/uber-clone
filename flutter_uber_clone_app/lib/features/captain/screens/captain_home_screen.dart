import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/captain/bloc/captain_bloc.dart';
import 'package:flutter_uber_clone_app/features/captain/widgets/user_ride_request_bottom_sheet.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/socket_service.dart';

class CaptainHomeScreen extends StatefulWidget {
  const CaptainHomeScreen({super.key});

  @override
  State<CaptainHomeScreen> createState() => _CaptainHomeScreenState();
}

class _CaptainHomeScreenState extends State<CaptainHomeScreen> {
  bool isPickUpSelected = true;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  CaptainBloc captainBloc = CaptainBloc();
  final LatLng _currentPosition = const LatLng(19.0338457, 73.0195871); // default
  late SocketService socketService;

  @override
  void dispose() {
    captainBloc.close();
    super.dispose();
  }

  void initSocket(String userId, String userType) {
    socketService.connect(userId: userId, userType: userType);
    //socketService.connect(userId: '6853fdf51246d822a9601ccc', userType: 'captain');
  }

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
    socketService = SocketService();
    captainBloc.add(GetCaptainProfileEvent());
  }

  void listenUserRequest() {
    socketService.socket.on('new-ride', (data) {
      AppLogger.i("New Ride Message $data");
      captainBloc.add(OpenBottomSheetOnUserRideReqEvent(data));
    });
  }

  void startLocationUpdates(String userId) {
    Timer.periodic(Duration(seconds: 10), (timer) {
      final data = {
        'userId': userId,
        'location': {
          'ltd': _currentPosition.latitude,
          'lng': _currentPosition.longitude,
        }
      };
      AppLogger.i('Data to be emit: $data');
      socketService.emit('update-location-captain', data);
    });
    AppLogger.i("📍 Started sending location updates every 10 seconds.");
  }


  /*Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return early
      return;
    }
    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId("currentLocation"),
          position: _currentPosition,
          infoWindow: InfoWindow(title: "You are here"),
        ),
      );
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 16));
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CaptainBloc, CaptainState>(
      bloc: captainBloc,
      listenWhen: (previous, current) => current is CaptainActionableState,
      buildWhen: (previous, current) => true,
      listener: (context, state) {
        if (state is FetchCaptainProfileState) {
          AppLogger.i("👨‍✈️ Captain profile fetched");
          initSocket(state.profile['_id'], 'captain');
          startLocationUpdates(state.profile['_id']);
          listenUserRequest();
        }
        if (state is OpenBottomSheetOnUserRideReqState) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            builder:
                (context) => BlocProvider.value(
                  value: captainBloc,
                  child: UserRideRequestBottomSheet(rideRequest: state.rideRequest),
                ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox.expand(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    // blue dot
                    myLocationButtonEnabled: true,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: Text(
                    'Uber',
                    style: TextStyle(
                      fontSize: AppSizes.fontXL,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 60,
                  child: GestureDetector(
                    onTap: () {
                      LocalStorageService.clearToken();
                      LocalStorageService.clearCurrentAccess();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.captainLoginScreen,
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.logout),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        AppWidgets.heightBox(AppSizes.padding10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(Icons.person),
                              ),
                              // Image.asset('assets/images/profile.jpg', width: 40, height: 40)),
                              AppWidgets.widthBox(AppSizes.padding10),
                              if (state is FetchCaptainProfileState)
                                Text(
                                  "${state.profile['fullname']['firstname'].toString().toUpperCase()} ${state.profile['fullname']['lastname'].toString().toUpperCase()}",
                                  style: TextStyle(
                                    fontSize: AppSizes.fontMedium,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹ 101.00",
                                    style: TextStyle(
                                      fontSize: AppSizes.fontLarge,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Earned",
                                    style: TextStyle(
                                      fontSize: AppSizes.fontSmall,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
