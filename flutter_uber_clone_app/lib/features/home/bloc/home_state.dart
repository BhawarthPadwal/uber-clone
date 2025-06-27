part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

sealed class HomeActionableState extends HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class MapSuggestionsLoadedState extends HomeState {
  final List<MapSuggestions> mapSuggestions;
  final List<String> description;
  MapSuggestionsLoadedState(this.mapSuggestions, this.description);
}

final class MapDistanceDurationLoadedState extends HomeActionableState {
  final List<VehicleFare> vehicleFare;
  final String distance;
  final String duration;
  MapDistanceDurationLoadedState(this.vehicleFare, this.distance, this.duration);
}

final class MapSuggestionsErrorState extends HomeActionableState {
  final String error;
  MapSuggestionsErrorState(this.error);
}

final class MapDistanceDurationErrorState extends HomeActionableState {
  final String error;
  MapDistanceDurationErrorState(this.error);
}

final class MapSuggestionsLoadingState extends HomeState {}

final class MapDistanceDurationLoadingState extends HomeState {}
