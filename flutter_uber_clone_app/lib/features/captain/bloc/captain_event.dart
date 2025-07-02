part of 'captain_bloc.dart';

@immutable
sealed class CaptainEvent {}

final class OpenBottomSheetOnUserRideReqEvent extends CaptainEvent {}

final class GetCaptainProfileEvent extends CaptainEvent {}