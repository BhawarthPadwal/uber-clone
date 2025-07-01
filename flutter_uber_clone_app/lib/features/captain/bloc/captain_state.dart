part of 'captain_bloc.dart';

@immutable
sealed class CaptainState {}

sealed class CaptainActionableState extends CaptainState {}

final class CaptainInitial extends CaptainState {}

final class OpenBottomSheetOnUserRideReqState extends CaptainActionableState {}
