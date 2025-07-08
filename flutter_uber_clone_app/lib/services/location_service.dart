import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() => _instance;

  LocationService._internal();

  StreamSubscription<Position>? _positionStreamSubscription;

  /// One-time location fetch
  Future<LatLng?> getCurrentLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  /// Start location updates + update marker set if provided
  void startLocationUpdates({
    required Function(LatLng) onLocationChanged,
    Set<Marker>? markerSet,
    String markerId = 'currentLocation',
    int distanceFilter = 10,
  }) async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    _positionStreamSubscription?.cancel();

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    ).listen((Position position) {
      final latLng = LatLng(position.latitude, position.longitude);

      // Optional: update marker
      if (markerSet != null) {
        markerSet.removeWhere((marker) => marker.markerId.value == markerId);
        markerSet.add(
          Marker(
            markerId: MarkerId(markerId),
            position: latLng,
            infoWindow: InfoWindow(title: "You are here"),
          ),
        );
      }

      onLocationChanged(latLng);
    });
  }

  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
