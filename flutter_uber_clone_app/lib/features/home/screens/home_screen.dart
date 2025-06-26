import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/features/auth/widgets/auth_widgets.dart';
import 'package:flutter_uber_clone_app/features/home/bloc/home_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/home_widgets.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

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

  LatLng _currentPosition = const LatLng(19.0338457, 73.0195871); // default

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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
  }

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
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionableState,
      buildWhen: (previous, current) => current is! HomeActionableState,
      listener: (context, state) {
        if (state is MapSuggestionsErrorState) {
          AppWidgets.showSnackbar(context, message: state.error);
        }
        // TODO: implement listener
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
                DraggableScrollableSheet(
                  controller: sheetController,
                  initialChildSize: 0.250,
                  // 30% of screen
                  minChildSize: 0.250,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandSheet();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: AppSizes.paddingM,
                          right: AppSizes.paddingM,
                          top: AppSizes.paddingXL,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 10),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find a trip',
                              style: TextStyle(
                                fontSize: AppSizes.fontXL,
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppWidgets.heightBox(AppSizes.padding20),
                            Flexible(
                              child: ListView(
                                controller: scrollController,
                                children: [
                                  TextField(
                                    controller: pickupController,
                                    onTap: _expandSheet,
                                    onChanged: (value) {
                                      setState(() {
                                        isPickUpSelected = true;
                                      });
                                      _onSearchChanged(value);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Pickup Location',
                                      prefixIcon: Icon(Icons.my_location),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  TextField(
                                    controller: destinationController,
                                    onTap: _expandSheet,
                                    onChanged: (value) {
                                      setState(() {
                                        isPickUpSelected = false;
                                      });
                                      _onSearchChanged(value);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Destination',
                                      prefixIcon: Icon(Icons.location_on),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Visibility(
                                    visible: false,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        LocalStorageService.clearToken();
                                      },
                                      child: Text('Logout'),
                                    ),
                                  ),
                                  state is MapSuggestionsLoadingState
                                      ? HomeWidgets.buildShimmerLoader()
                                      : state is MapSuggestionsLoadedState
                                      ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: state.description.length,
                                        itemBuilder: (context, index) {
                                          final description =
                                              state.description[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.grey))),
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                  ),
                                              leading: const Icon(
                                                Icons.location_on,
                                                color: AppColors.black,
                                              ),
                                              title: Text(
                                                description,
                                                style: const TextStyle(
                                                  fontSize: AppSizes.fontMedium,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              onTap: () {
                                                isPickUpSelected
                                                    ? pickupController.text =
                                                        description
                                                    : destinationController.text =
                                                        description;
                                              },
                                            ),
                                          );
                                        },
                                      )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
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
