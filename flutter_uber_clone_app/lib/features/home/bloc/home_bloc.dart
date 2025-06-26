import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_uber_clone_app/services/api_service.dart';
import 'package:flutter_uber_clone_app/utils/api/api_manager.dart';
import 'package:flutter_uber_clone_app/utils/api/api_req_endpoints.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:meta/meta.dart';

import '../models/map_suggestion_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetMapSuggestionsEvent>(getMapSuggestionsEvent);
  }


  FutureOr<void> getMapSuggestionsEvent(GetMapSuggestionsEvent event, Emitter<HomeState> emit) async {
    emit(MapSuggestionsLoadingState());
    try {
      final result = await ApiManager.getWithHeader(ApiReqEndpoints.getMapSuggestion(event.query));
      AppLogger.d(result);

      if (result['status'] == 200) {
        final List<MapSuggestions> suggestions = mapSuggestionsFromJson(json.encode(result['data']));
        final List<String> descriptions = suggestions.map((s) => s.description).toList();

        AppLogger.d(suggestions);
        AppLogger.d(descriptions);

        emit(MapSuggestionsLoadedState(
          suggestions,
          descriptions,
        ));
      } else {
        emit(MapSuggestionsErrorState(result['data']['message']));
      }
    } catch (e) {
      AppLogger.e(e);
      emit(MapSuggestionsErrorState(e.toString()));
    }
  }


/*FutureOr<void> getMapSuggestionsEvent(GetMapSuggestionsEvent event, Emitter<HomeState> emit) async {
    emit (MapSuggestionsLoadingState());
    try {
      final result = await ApiManager.getWithHeader(ApiReqEndpoints.getMapSuggestion(event.query));
      AppLogger.d(result);
      if (result['status'] == 200) {
        emit (MapSuggestionsLoadedState(mapSuggestionsFromJson(result['data'])));
      } else {
        emit (MapSuggestionsErrorState(result['data']['message']));
      }
    } catch (e) {
      AppLogger.e(e);
      emit (MapSuggestionsErrorState(e.toString()));
    }
  }*/
}
