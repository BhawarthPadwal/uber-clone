part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

sealed class HomeActionableState extends HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class MapSuggestionsLoadedState extends HomeState {
  final List<MapSuggestions> mapSuggestions;
  final List<String> description;
  MapSuggestionsLoadedState(this.mapSuggestions, this.description);
}

final class MapDistanceDurationLoadedState extends HomeActionableState {}

final class MapDistanceDurationListLoadedState extends HomeState {
  final List<VehicleFare> vehicleFare;
  final String distance;
  final String duration;
  final int selectedVehicleIndex;
  MapDistanceDurationListLoadedState(this.vehicleFare, this.distance, this.duration, this.selectedVehicleIndex);
}

final class MapSuggestionsErrorState extends HomeActionableState {
  final String error;
  MapSuggestionsErrorState(this.error);
}

final class MapDistanceDurationErrorState extends HomeActionableState {
  final String error;
  MapDistanceDurationErrorState(this.error);
}

final class MapSuggestionsLoadingState extends HomeState {}

final class MapDistanceDurationLoadingState extends HomeState {}

final class OpenBottomSheetState extends HomeActionableState {}

final class OpenSearchCaptainBottomSheetState extends HomeActionableState {
  final List<VehicleFare> vehicleFare;
  final Map<String, dynamic> distanceDuration;
  OpenSearchCaptainBottomSheetState(this.vehicleFare, this.distanceDuration);
}

final class RideCreatedState extends HomeActionableState {
  final Map<String, dynamic> rideData;
  RideCreatedState(this.rideData);
}

final class RideCreatedLoadingState extends HomeState {}

final class RideCreatedResponseMessageState extends HomeState {
  final String error;
  RideCreatedResponseMessageState(this.error);
}


