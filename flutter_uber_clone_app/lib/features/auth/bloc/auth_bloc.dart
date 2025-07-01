import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/api/api_manager.dart';
import 'package:flutter_uber_clone_app/utils/api/api_req_endpoints.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<UserLoginEvent>(userLoginEvent);
    on<UserSignupEvent>(userSignupEvent);
    on<CaptainLoginEvent>(captainLoginEvent);
    on<CaptainSignupEvent>(captainSignupEvent);
  }

  FutureOr<void> userLoginEvent(
    UserLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await ApiManager.post(ApiReqEndpoints.getUserLogin(), {
        "email": event.email,
        "password": event.password,
      });
      AppLogger.d(result);
      if (result['status'] == 200) {
        LocalStorageService.saveToken(result['data']['token']);
        LocalStorageService.setCurrentAccess('user');
        emit(NavigateToUserHomeScreen());
      } else {
        emit(AuthFailureState(message: result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.e(e);
    }
  }

  FutureOr<void> userSignupEvent(
    UserSignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await ApiManager.post(ApiReqEndpoints.getUserRegister(), {
        "fullname": event.fullname,
        "email": event.email,
        "password": event.password,
      });
      AppLogger.d(result);
      if (result['status'] == 201) {
        LocalStorageService.saveToken(result['data']['token']);
        emit(NavigateToUserLoginScreenState());
      } else {
        emit(AuthFailureState(message: result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.e(e);
    }
  }

  FutureOr<void> captainLoginEvent(
    CaptainLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await ApiManager.post(ApiReqEndpoints.getCaptainLogin(), {
        "email": event.email,
        "password": event.password,
      });
      AppLogger.d(result);
      if (result['status'] == 200) {
        LocalStorageService.saveToken(result['data']['token']);
        LocalStorageService.setCurrentAccess('captain');
        emit(NavigateToCaptainHomeScreen());
      } else {
        emit(AuthFailureState(message: result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.e(e);
    }
  }

  FutureOr<void> captainSignupEvent(
    CaptainSignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await ApiManager.post(ApiReqEndpoints.getCaptainSignup(), {
        "fullname": event.fullname,
        "email": event.email,
        "password": event.password,
        "vehicle": event.vehicle,
      });
      AppLogger.d(result);
      if (result['status'] == 201) {
        LocalStorageService.saveToken(result['data']['token']);
        emit(NavigateToCaptainLoginScreenState());
      } else {
        emit(AuthFailureState(message: result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      emit(AuthFailureState(message: e.toString()));
      AppLogger.e(e);
    }
  }
}
