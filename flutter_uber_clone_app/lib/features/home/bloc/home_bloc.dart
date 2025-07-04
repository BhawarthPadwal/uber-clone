import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_uber_clone_app/features/home/models/vehicle_fare_model.dart';
import 'package:flutter_uber_clone_app/services/api_service.dart';
import 'package:flutter_uber_clone_app/utils/api/api_manager.dart';
import 'package:flutter_uber_clone_app/utils/api/api_req_endpoints.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:meta/meta.dart';

import '../../../services/socket_service.dart';
import '../models/map_suggestion_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetMapSuggestionsEvent>(getMapSuggestionsEvent);
    on<GetDistanceDurationFareEvent>(getDistanceDurationFare);
    on<OpenBottomSheetEvent>(openBottomSheetEvent);
    on<SelectedVehicleIndexEvent>(selectedVehicleIndexEvent);
    on<OpenSearchCaptainBottomSheetEvent>(openSearchCaptainBottomSheetEvent);
    on<RideCreatedEvent>(rideCreatedEvent);
    on<GetUserProfileEvent>(getUserProfileEvent);
    on<OpenBottomSheetOnCaptainConfirmationEvent>(openBottomSheetOnCaptainConfirmationEvent);
    on<CancelRideEvent>(cancelRideEvent);
    on<ClearSuggestionsEvent>(clearSuggestionsEvent);
    on<UpdateCurrentStateToRideStartedEvent>(updateCurrentStateToRideStartedEvent);
    on<UpdateCurrentStateToRideEndedEvent>(updateCurrentStateToRideEndedEvent);
  }

  FutureOr<void> getMapSuggestionsEvent(
    GetMapSuggestionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(MapSuggestionsLoadingState());
    try {
      final result = await ApiManager.getWithHeader(
        ApiReqEndpoints.getMapSuggestion(event.query),
      );
      AppLogger.d(result);

      if (result['status'] == 200) {
        final List<MapSuggestions> suggestions = mapSuggestionsFromJson(
          json.encode(result['data']),
        );
        final List<String> descriptions =
            suggestions.map((s) => s.description).toList();

        AppLogger.d(suggestions);
        AppLogger.d(descriptions);

        emit(MapSuggestionsLoadedState(suggestions, descriptions));
      } else {
        emit(MapSuggestionsErrorState(result['data']['message']));
      }
    } catch (e) {
      AppLogger.e(e);
      emit(MapSuggestionsErrorState(e.toString()));
    }
  }

  FutureOr<void> getDistanceDurationFare(
    GetDistanceDurationFareEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(MapDistanceDurationLoadingState());
    try {
      final result = await ApiManager.getWithHeader(
        ApiReqEndpoints.getFare(event.pickup, event.destination),
      );
      AppLogger.d(result);
      if (result['status'] == 200) {
        final Map<String, dynamic> fare = result['data']['fare'];
        final distance = result['data']['distanceTime']['distance']['text'];
        final duration = result['data']['distanceTime']['duration']['text'];
        AppLogger.d(fare);
        AppLogger.d(distance);
        AppLogger.d(duration);
        final List<dynamic> vehicleFare =
            fare.entries.map((e) {
              return VehicleFare(type: e.key, amount: e.value);
            }).toList();

        final List<VehicleFare> vehicleFareList =
            fare.entries
                .map((e) => VehicleFare(type: e.key, amount: e.value))
                .toList();

        emit(
          MapDistanceDurationListLoadedState(
            vehicleFareList,
            distance,
            duration,
            0,
          ),
        );
      } else {
        emit(MapDistanceDurationErrorState(result['data']['message']));
      }
    } catch (e) {
      AppLogger.e(e);
      emit(MapDistanceDurationErrorState(e.toString()));
    }
  }

  FutureOr<void> openBottomSheetEvent(
    OpenBottomSheetEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(OpenBottomSheetState());
  }

  FutureOr<void> selectedVehicleIndexEvent(
    SelectedVehicleIndexEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(
      MapDistanceDurationListLoadedState(
        event.vehicleFare,
        event.distance,
        event.duration,
        event.index,
      ),
    );
  }

  FutureOr<void> openSearchCaptainBottomSheetEvent(
    OpenSearchCaptainBottomSheetEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(OpenSearchCaptainBottomSheetState(event.fare, event.distanceDuration));
  }

  FutureOr<void> rideCreatedEvent(
    RideCreatedEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(RideCreatedLoadingState());
    try {
      final result = await ApiManager.postWithHeader(
        ApiReqEndpoints.postRideCreated(),
        {
          "pickup": event.pickup,
          "destination": event.destination,
          'vehicleType': event.vehicleType,
        },
      );
      AppLogger.d(result);
      if (result['status'] == 201) {
        emit(RideCreatedState(result['data']));
      } else {
        emit(RideCreatedResponseMessageState(result['data']['message']));
      }
    } catch (e) {
      AppLogger.e(e);
      emit(RideCreatedResponseMessageState(e.toString()));
    }
  }

  FutureOr<void> getUserProfileEvent(GetUserProfileEvent event, Emitter<HomeState> emit) async {
    emit(FetchUserProfileLoadingState());
    try {
      final result = await ApiManager.getWithHeader(ApiReqEndpoints.getUserProfile());
      AppLogger.d(result);
      final Map<String, dynamic> userProfile = result['data'];
      AppLogger.d(userProfile);
      if (result['status'] == 200) {
        emit(FetchUserProfileState(userProfile));
        AppLogger.d(result['data']);
      } else {
        emit(FetchUserProfileMessageResponseState(result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.e(e);
    }
  }

  FutureOr<void> openBottomSheetOnCaptainConfirmationEvent(OpenBottomSheetOnCaptainConfirmationEvent event, Emitter<HomeState> emit) {
    emit(OpenBottomSheetOnCaptainConfirmationState(event.data));
  }

  FutureOr<void> cancelRideEvent(CancelRideEvent event, Emitter<HomeState> emit) {
  }


  FutureOr<void> clearSuggestionsEvent(ClearSuggestionsEvent event, Emitter<HomeState> emit) {
    emit(MapSuggestionsLoadedState([], []));
  }

  FutureOr<void> updateCurrentStateToRideStartedEvent(UpdateCurrentStateToRideStartedEvent event, Emitter<HomeState> emit) {
    emit(UpdateCurrentStateToRideStartedState());
  }

  FutureOr<void> updateCurrentStateToRideEndedEvent(UpdateCurrentStateToRideEndedEvent event, Emitter<HomeState> emit) {
    emit(UpdateCurrentStateToRideEndedState());
  }
}
