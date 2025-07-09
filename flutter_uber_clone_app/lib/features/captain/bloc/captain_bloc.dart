import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:meta/meta.dart';

import '../../../utils/api/api_manager.dart';
import '../../../utils/api/api_req_endpoints.dart';

part 'captain_event.dart';
part 'captain_state.dart';

class CaptainBloc extends Bloc<CaptainEvent, CaptainState> {
  CaptainBloc() : super(CaptainInitial()) {
    on<OpenBottomSheetOnUserRideReqEvent>(openBottomSheetOnUserRideReqEvent);
    on<GetCaptainProfileEvent>(getCaptainProfileEvent);
    on<AcceptRideEvent>(acceptRideEvent);
    on<StartRideEvent>(startRideEvent);
    on<EndRideEvent>(endRideEvent);
  }

  FutureOr<void> openBottomSheetOnUserRideReqEvent(
    OpenBottomSheetOnUserRideReqEvent event,
    Emitter<CaptainState> emit,
  ) {
    emit(OpenBottomSheetOnUserRideReqState(event.rideRequest));
  }

  FutureOr<void> getCaptainProfileEvent(
    GetCaptainProfileEvent event,
    Emitter<CaptainState> emit,
  ) async {
    emit(FetchCaptainProfileLoadingState());
    try {
      final result = await ApiManager.getWithHeader(
        ApiReqEndpoints.getCaptainProfile(),
      );
      AppLogger.d(result);
      final Map<String, dynamic> captainProfile = result['data'];
      AppLogger.d(captainProfile);
      if (result['status'] == 200) {
        emit(FetchCaptainProfileState(captainProfile));
        AppLogger.d(result['data']);
      } else {
        emit(FetchCaptainProfileResponseState(result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.e(e);
    }
  }

  FutureOr<void> acceptRideEvent(
    AcceptRideEvent event,
    Emitter<CaptainState> emit,
  ) async {
    emit(AcceptRideLoadingState());
    try {
      final result = await ApiManager.getWithHeader(
        ApiReqEndpoints.confirmRide(event.rideId),
      );
      AppLogger.d(result);
      final Map<String, dynamic> ride = result['data'];
      if (result['status'] == 200) {
        emit(AcceptRideState(ride));
        AppLogger.i('Ride Confirmed Response: ');
        AppLogger.d(result['data']);
      } else {
        emit(AcceptRideResponseState(result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.i('Ride Confirmed Response: ');
      AppLogger.e(e);
    }
  }

  FutureOr<void> startRideEvent(
    StartRideEvent event,
    Emitter<CaptainState> emit,
  ) async {
    emit(StartRideLoadingState());
    try {
      final result = await ApiManager.getWithHeader(
        ApiReqEndpoints.startRide(event.rideId, event.otp),
      );
      AppLogger.d(result);
      final Map<String, dynamic> ride = result['data'];
      if (result['status'] == 200) {
        emit(StartRideState(ride));
        AppLogger.i('Start Ride Response: ');
        AppLogger.d(result['data']);
      } else {
        emit(StartRideResponseState(result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.i('Start Ride Response: ');
      AppLogger.e(e);
      emit(StartRideResponseState(e.toString()));
    }
  }

  FutureOr<void> endRideEvent(
    EndRideEvent event,
    Emitter<CaptainState> emit,
  ) async {
    emit(EndRideLoadingState());
    try {
      final result = await ApiManager.getWithHeader(
        ApiReqEndpoints.endRide(event.rideId),
      );
      AppLogger.d(result);
      final Map<String, dynamic> ride = result['data'];
      if (result['status'] == 200) {
        emit(EndRideState(ride));
        AppLogger.i('End Ride Response: ');
        AppLogger.d(result['data']);
      } else {
        AppLogger.i('End Ride Response: ');
        emit(EndRideResponseState(result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.e(e);
      emit(EndRideResponseState(e.toString()));
    }
  }
}
