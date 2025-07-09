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

final class OpenSearchCaptainBottomSheetEvent extends HomeEvent {
  final List<VehicleFare> fare;
  final Map<String, dynamic> distanceDuration;
  OpenSearchCaptainBottomSheetEvent(this.fare, this.distanceDuration);
}

final class OpenBottomSheetOnCaptainConfirmationEvent extends HomeEvent {
  final Map<String, dynamic> data;
  OpenBottomSheetOnCaptainConfirmationEvent(this.data);
}

final class RideCreatedEvent extends HomeEvent {
  final String pickup;
  final String destination;
  final String vehicleType;
  RideCreatedEvent(this.pickup, this.destination, this.vehicleType);
}

final class GetUserProfileEvent extends HomeEvent {}

final class CancelRideEvent extends HomeEvent {
  final String rideId;
  CancelRideEvent(this.rideId);
}

final class ClearSuggestionsEvent extends HomeEvent {}

final class UpdateCurrentStateToRideStartedEvent extends HomeEvent {}

final class UpdateCurrentStateToRideEndedEvent extends HomeEvent {}

final class MakePaymentEvent extends HomeEvent {
  final String rideId;
  MakePaymentEvent(this.rideId);
}
