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

