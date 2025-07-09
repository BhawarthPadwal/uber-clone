part of 'captain_bloc.dart';

@immutable
sealed class CaptainEvent {}

final class OpenBottomSheetOnUserRideReqEvent extends CaptainEvent {
  final Map<String, dynamic> rideRequest;
  OpenBottomSheetOnUserRideReqEvent(this.rideRequest);
}

final class GetCaptainProfileEvent extends CaptainEvent {}

final class AcceptRideEvent extends CaptainEvent {
  final String rideId;
  AcceptRideEvent(this.rideId);
}

final class StartRideEvent extends CaptainEvent {
  final String rideId;
  final String otp;
  StartRideEvent(this.rideId, this.otp);
}

final class EndRideEvent extends CaptainEvent {
  final String rideId;
  EndRideEvent(this.rideId);
}
