part of 'captain_bloc.dart';

@immutable
sealed class CaptainEvent {}

final class OpenBottomSheetOnUserRideReqEvent extends CaptainEvent {
  final Map<String, dynamic> userRequest;
  OpenBottomSheetOnUserRideReqEvent(this.userRequest);

}

final class GetCaptainProfileEvent extends CaptainEvent {}