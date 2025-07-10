import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/captain/bloc/captain_bloc.dart';
import 'package:flutter_uber_clone_app/features/captain/widgets/user_ride_request_bottom_sheet.dart';
import 'package:flutter_uber_clone_app/services/location_service.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_colors.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_strings.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../services/language_provider.dart';
import '../../../services/socket_service.dart';
import '../../../utils/constants/app_assets.dart';

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
  LatLng _currentPosition = const LatLng(19.0338457, 73.0195871); // default
  late SocketService socketService;
  Map<String, dynamic>? captainProfile;

  @override
  void dispose() {
    captainBloc.close();
    LocationService().stopLocationUpdates();
    super.dispose();
  }

  void initSocket(String userId, String userType) {
    socketService.connect(userId: userId, userType: userType);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    socketService = SocketService();
    captainBloc.add(GetCaptainProfileEvent());
  }

  void getLocation() {
    // One-time fetch
    LocationService().getCurrentLocation().then((pos) {
      if (pos != null) {
        setState(() {
          _currentPosition = pos;
          _markers.add(
            Marker(
              markerId: const MarkerId("currentLocation"),
              position: pos,
              infoWindow: InfoWindow(
                title: AppLocalizations.of(context)!.youAreHere,
              ),
            ),
          );
        });
      }
    });
    // Real-time updates with marker handling
    LocationService().startLocationUpdates(
      onLocationChanged: (LatLng pos) {
        setState(() {
          _currentPosition = pos;
        });
      },
      markerSet: _markers,
    );
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
        },
      };
      AppLogger.i('Data to be emit: $data');
      socketService.emit('update-location-captain', data);
    });
    AppLogger.i("📍 Started sending location updates every 10 seconds.");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CaptainBloc, CaptainState>(
      bloc: captainBloc,
      listenWhen: (previous, current) => current is CaptainActionableState,
      buildWhen: (previous, current) => true,
      listener: (context, state) {
        if (state is FetchCaptainProfileState) {
          AppLogger.i("👨‍✈️ Captain profile fetched");
          setState(() {
            captainProfile = state.profile;
          });
          initSocket(state.profile['_id'], 'captain');
          startLocationUpdates(state.profile['_id']);
          listenUserRequest();
        }
        if (state is OpenBottomSheetOnUserRideReqState) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            enableDrag: false,
            isDismissible: false,
            builder:
                (context) => BlocProvider.value(
                  value: captainBloc,
                  child: UserRideRequestBottomSheet(
                    rideRequest: state.rideRequest,
                  ),
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
                    myLocationEnabled: true, // blue dot
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
                    AppLocalizations.of(context)!.appName,
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
                  right: 10,
                  top: 110,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("Select Language"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("English"),
                                    onTap: () {
                                      LanguageProvider.of(
                                        context,
                                      ).setLocale(const Locale('en'));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("मराठी"),
                                    onTap: () {
                                      LanguageProvider.of(
                                        context,
                                      ).setLocale(const Locale('mr'));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("हिंदी"),
                                    onTap: () {
                                      LanguageProvider.of(
                                        context,
                                      ).setLocale(const Locale('hi'));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("ಕನ್ನಡ"),
                                    onTap: () {
                                      LanguageProvider.of(
                                        context,
                                      ).setLocale(const Locale('kn'));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Русский"),
                                    onTap: () {
                                      LanguageProvider.of(
                                        context,
                                      ).setLocale(const Locale('ru'));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("中文"),
                                    onTap: () {
                                      LanguageProvider.of(
                                        context,
                                      ).setLocale(const Locale('zh'));
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(AppAssets.language),
                      ),
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
                              if (captainProfile != null)
                                Text(
                                  "${captainProfile!['fullname']['firstname'].toString().toUpperCase()} "
                                  "${captainProfile!['fullname']['lastname'].toString().toUpperCase()}",
                                  style: TextStyle(
                                    fontSize: AppSizes.fontMedium,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    AppLocalizations.of(context)!.loading,
                                    style: TextStyle(
                                      fontSize: AppSizes.fontSmall,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ), // Or a placeholder
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
                                    AppLocalizations.of(context)!.earned,
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
