import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/config/router/app_routes.dart';
import 'package:flutter_uber_clone_app/features/home/bloc/home_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/choose_vehicles_bottom_sheet.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/home_widgets.dart';
import 'package:flutter_uber_clone_app/services/location_service.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_assets.dart';
import 'package:flutter_uber_clone_app/utils/constants/app_sizes.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../services/language_provider.dart';
import '../../../services/socket_service.dart';
import '../../../utils/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final FocusNode pickupFocusNode = FocusNode();
  final FocusNode destinationFocusNode = FocusNode();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  HomeBloc homeBloc = HomeBloc();
  Timer? _debounce;
  bool isPickUpSelected = true;
  bool isPanelExpanded = false;
  Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(19.0338457, 73.0195871); // default

  late SocketService socketService;
  late String pickup;
  late String destination;

  void initSocket(String userId, String userType) {
    socketService.connect(userId: userId, userType: userType);
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

  @override
  void initState() {
    super.initState();
    getLocation();
    socketService = SocketService();
    homeBloc.add(GetUserProfileEvent());
  }

  void _expandSheet() {
    sheetController.animateTo(
      1.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _collapseSheet() {
    sheetController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    pickupController.clear();
    destinationController.clear();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      AppLogger.i('Debounced search for: $query');
      if (query.isNotEmpty && query.length >= 3) {
        homeBloc.add(GetMapSuggestionsEvent(query));
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    socketService.socket.disconnect();
    homeBloc.close();
    pickupController.dispose();
    destinationController.dispose();
    pickupFocusNode.dispose();
    destinationFocusNode.dispose();
    LocationService().stopLocationUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionableState,
        buildWhen: (previous, current) => current is! HomeActionableState,
        listener: (context, state) {
          if (state is FetchUserProfileState) {
            AppLogger.i("👨‍✈️ User profile fetched");
            initSocket(state.userProfile['_id'], 'user');
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
                  child: ChooseVehiclesBottomSheet(
                    points: {"pickup": pickup, "destination": destination},
                  ),
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
                      myLocationButtonEnabled: true,
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
                  DraggableScrollableSheet(
                    controller: sheetController,
                    initialChildSize: 0.275,
                    minChildSize: 0.275,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.findATrip,
                                        style: TextStyle(
                                          fontSize: AppSizes.fontXL,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      AppWidgets.heightBox(AppSizes.padding20),
                                      TextField(
                                        controller: pickupController,
                                        focusNode: pickupFocusNode,
                                        onTap: _expandSheet,
                                        onChanged: (value) {
                                          setState(() {
                                            isPickUpSelected = true;
                                          });
                                          _onSearchChanged(value);
                                        },
                                        decoration: InputDecoration(
                                          labelText:
                                              AppLocalizations.of(
                                                context,
                                              )!.pickupLocation,
                                          prefixIcon: Icon(Icons.my_location),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: destinationController,
                                        focusNode: destinationFocusNode,
                                        onTap: _expandSheet,
                                        onChanged: (value) {
                                          setState(() {
                                            isPickUpSelected = false;
                                          });
                                          _onSearchChanged(value);
                                        },
                                        decoration: InputDecoration(
                                          labelText:
                                              AppLocalizations.of(
                                                context,
                                              )!.destination,
                                          prefixIcon: Icon(Icons.location_on),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      if (pickupController.text.isNotEmpty &&
                                          destinationController.text.isNotEmpty)
                                        GestureDetector(
                                          onTap: () {
                                            pickup = pickupController.text;
                                            destination =
                                                destinationController.text;
                                            homeBloc.add(
                                              GetDistanceDurationFareEvent(
                                                pickupController.text,
                                                destinationController.text,
                                              ),
                                            );
                                            homeBloc.add(
                                              OpenBottomSheetEvent(),
                                            );
                                            setState(() {
                                              _collapseSheet();
                                            });
                                            pickupController.clear();
                                            destinationController.clear();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              vertical: AppSizes.paddingM,
                                            ),
                                            height: 60,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width,
                                            decoration: BoxDecoration(
                                              color: AppColors.black,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  AppSizes.padding10,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.searchVehicles,
                                                style: TextStyle(
                                                  fontSize: AppSizes.fontMedium,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (state is MapSuggestionsLoadingState)
                                        HomeWidgets.buildShimmerLoader()
                                      else if (state
                                          is MapSuggestionsLoadedState)
                                        ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  state.description.length,
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
                                                              AppSizes
                                                                  .fontMedium,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        if (isPickUpSelected) {
                                                          pickupController
                                                                  .text =
                                                              description;
                                                          homeBloc.add(
                                                            ClearSuggestionsEvent(),
                                                          );
                                                          FocusScope.of(
                                                            context,
                                                          ).requestFocus(
                                                            destinationFocusNode,
                                                          );
                                                        } else {
                                                          destinationController
                                                                  .text =
                                                              description;
                                                          homeBloc.add(
                                                            ClearSuggestionsEvent(),
                                                          );
                                                          FocusScope.of(
                                                            context,
                                                          ).unfocus();
                                                        }
                                                      },
                                                    ),
                                                    const Divider(
                                                      height: 1,
                                                      indent: 20,
                                                      endIndent: 20,
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
      ),
    );
  }
}
