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

final class MapSuggestionsErrorState extends HomeActionableState {
  final String error;
  MapSuggestionsErrorState(this.error);
}

final class MapSuggestionsEmptyState extends HomeActionableState {
  final String error;
  MapSuggestionsEmptyState(this.error);
}

final class MapSuggestionsLoadingState extends HomeState {}
