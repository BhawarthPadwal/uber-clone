part of 'captain_bloc.dart';

@immutable
sealed class CaptainEvent {}

final class OpenBottomSheetOnUserRideReqEvent extends CaptainEvent {
  final Map<String, dynamic> rideRequest;
  OpenBottomSheetOnUserRideReqEvent(this.rideRequest);
}

final class GetCaptainProfileEvent extends CaptainEvent {}