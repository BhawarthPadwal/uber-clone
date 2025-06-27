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
