import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/home/bloc/home_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/choose_vehicles_bottom_sheet.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/home_widgets.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../services/socket_service.dart';
import '../../../utils/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPanelExpanded = false;
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  HomeBloc homeBloc = HomeBloc();
  Timer? _debounce;
  bool isPickUpSelected = true;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  late SocketService socketService;
  LatLng _currentPosition = const LatLng(19.0338457, 73.0195871); // default

  void initSocket(String userId, String userType) {
    socketService.connect(userId: userId, userType: userType);
    //socketService.connect(userId: '6853fdf51246d822a9601ccc', userType: 'captain');
  }

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
    socketService = SocketService();
    homeBloc.add(GetUserProfileEvent());
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

  void _expandSheet() {
    sheetController.animateTo(
      1.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      AppLogger.i('Debounced search for: $query');
      homeBloc.add(GetMapSuggestionsEvent(query));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    socketService.socket.disconnect();
    homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionableState,
      buildWhen: (previous, current) => current is! HomeActionableState,
      listener: (context, state) {
        if (state is FetchUserProfileState) {
          AppLogger.i("👨‍✈️ User profile fetched");
          initSocket(state.userProfile['_id'], 'user');
          //listenCaptainConfirmation();
        }
        if (state is MapSuggestionsErrorState) {
          AppWidgets.showSnackbar(context, message: state.error);
        }
        if (state is OpenBottomSheetState) {
          AppLogger.d("Inside state");
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BlocProvider.value(
                value: homeBloc,
                child: ChooseVehiclesBottomSheet(points: {
                  "pickup": pickupController.text,
                  "destination": destinationController.text
                }),
              );
            },
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
                        AppRoutes.userLoginScreen,
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
                DraggableScrollableSheet(
                  controller: sheetController,
                  initialChildSize: 0.3,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          AppWidgets.heightBox(AppSizes.padding10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Find a trip',
                                      style: TextStyle(
                                        fontSize: AppSizes.fontXL,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    AppWidgets.heightBox(AppSizes.padding20),
                                    TextField(
                                      controller: pickupController,
                                      onTap: _expandSheet,
                                      onChanged: (value) {
                                        setState(() {
                                          isPickUpSelected = true;
                                        });
                                        _onSearchChanged(value);
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Pickup Location',
                                        prefixIcon: Icon(Icons.my_location),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: destinationController,
                                      onTap: _expandSheet,
                                      onChanged: (value) {
                                        setState(() {
                                          isPickUpSelected = false;
                                        });
                                        _onSearchChanged(value);
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Destination',
                                        prefixIcon: Icon(Icons.location_on),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Visibility(
                                      visible: false,
                                      child: ElevatedButton(
                                        onPressed:
                                            () =>
                                                LocalStorageService.clearToken(),
                                        child: const Text('Logout'),
                                      ),
                                    ),
                                    if (state is MapSuggestionsLoadingState)
                                      HomeWidgets.buildShimmerLoader()
                                    else if (state is MapSuggestionsLoadedState)
                                      ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: state.description.length,
                                            itemBuilder: (context, index) {
                                              final description =
                                                  state.description[index];
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.location_on,
                                                      color: AppColors.black,
                                                    ),
                                                    title: Text(
                                                      description,
                                                      style: const TextStyle(
                                                        fontSize:
                                                            AppSizes.fontMedium,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (isPickUpSelected) {
                                                        pickupController.text =
                                                            description;
                                                      } else {
                                                        destinationController
                                                            .text = description;
                                                      }

                                                      if (pickupController
                                                              .text
                                                              .isNotEmpty &&
                                                          destinationController
                                                              .text
                                                              .isNotEmpty) {
                                                        homeBloc.add(
                                                          GetDistanceDurationFareEvent(
                                                            pickupController
                                                                .text,
                                                            destinationController
                                                                .text,
                                                          ),
                                                        );
                                                        homeBloc.add(
                                                          OpenBottomSheetEvent(),
                                                        );
                                                        /*setState(() {
                                                          _collapseSheet();
                                                        });*/
                                                      }
                                                    },
                                                  ),
                                                  const Divider(
                                                    height: 1,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                          .animate()
                                          .fade(duration: 1000.ms)
                                          .slideY(
                                            begin: 0.2,
                                            duration: 1000.ms,
                                            curve: Curves.easeOut,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
