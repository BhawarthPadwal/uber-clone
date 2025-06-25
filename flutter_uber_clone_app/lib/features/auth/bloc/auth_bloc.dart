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
  }

  FutureOr<void> userLoginEvent(UserLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final result = await ApiManager.post(ApiReqEndpoints.getUserLogin(), {
        "email" : event.email,
        "password" : event.password,
      });
      AppLogger.d(result);
      if (result['status'] == 200) {
        LocalStorageService.saveToken(result['data']['token']);
        emit(NavigateToHomeScreen());
      } else {
        emit(AuthFailureState(message: result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.e(e);
    }
  }

  FutureOr<void> userSignupEvent(UserSignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final result = await ApiManager.post(ApiReqEndpoints.getCaptainLogin(), {
        "email" : event.email,
        "password" : event.password,
      });
      AppLogger.d(result);
      if (result['status'] == 200) {
        LocalStorageService.saveToken(result['data']['token']);
        emit(NavigateToHomeScreen());
      } else {
        emit(AuthFailureState(message: result['data']['message']));
        AppLogger.e(result['data']['message']);
      }
    } catch (e) {
      AppLogger.e(e);
    }

  }
}
