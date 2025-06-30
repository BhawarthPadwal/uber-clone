part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class GetMapSuggestionsEvent extends HomeEvent {
  final String query;

  GetMapSuggestionsEvent(this.query);
}

final class GetDistanceDurationFareEvent extends HomeEvent {
  final String pickup;
  final String destination;

  GetDistanceDurationFareEvent(this.pickup, this.destination);
}

final class SelectedVehicleIndexEvent extends HomeEvent {
  final List<VehicleFare> vehicleFare;
  final String distance;
  final String duration;
  final int index;

  SelectedVehicleIndexEvent(
    this.vehicleFare,
    this.distance,
    this.duration,
    this.index,
  );
}

final class OpenBottomSheetEvent extends HomeEvent {}

final class OpenSearchCaptainBottomSheetEvent extends HomeEvent {}

final class RideCreatedEvent extends HomeEvent {}
