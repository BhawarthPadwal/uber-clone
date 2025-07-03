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
  }

  FutureOr<void> openBottomSheetOnUserRideReqEvent(OpenBottomSheetOnUserRideReqEvent event, Emitter<CaptainState> emit) {
    emit(OpenBottomSheetOnUserRideReqState(event.rideRequest));
  }

  FutureOr<void> getCaptainProfileEvent(GetCaptainProfileEvent event, Emitter<CaptainState> emit) async {
    emit(FetchCaptainProfileLoadingState());
    try {
      final result = await ApiManager.getWithHeader(ApiReqEndpoints.getCaptainProfile());
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
}
