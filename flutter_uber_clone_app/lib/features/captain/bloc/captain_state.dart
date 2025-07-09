part of 'captain_bloc.dart';

@immutable
sealed class CaptainState {}

sealed class CaptainActionableState extends CaptainState {}

final class CaptainInitial extends CaptainState {}

final class OpenBottomSheetOnUserRideReqState extends CaptainActionableState {
  final Map<String, dynamic> rideRequest;
  OpenBottomSheetOnUserRideReqState(this.rideRequest);
}

final class FetchCaptainProfileLoadingState extends CaptainState {}

final class FetchCaptainProfileState extends CaptainActionableState {
  final Map<String, dynamic> profile;
  FetchCaptainProfileState(this.profile);
}

final class FetchCaptainProfileResponseState extends CaptainState {
  final String message;
  FetchCaptainProfileResponseState(this.message);
}

final class AcceptRideLoadingState extends CaptainState {}

final class AcceptRideState extends CaptainActionableState {
  final Map<String, dynamic> ride;
  AcceptRideState(this.ride);
}

final class AcceptRideResponseState extends CaptainState {
  final String message;
  AcceptRideResponseState(this.message);
}

final class StartRideLoadingState extends CaptainState {}

final class StartRideState extends CaptainState {
  final Map<String, dynamic> ride;
  StartRideState(this.ride);
}

final class StartRideResponseState extends CaptainActionableState {
  final String message;
  StartRideResponseState(this.message);
}

final class EndRideLoadingState extends CaptainState {}

final class EndRideState extends CaptainState {
  final Map<String, dynamic> ride;
  EndRideState(this.ride);
}

final class EndRideResponseState extends CaptainActionableState {
  final String message;
  EndRideResponseState(this.message);
}
