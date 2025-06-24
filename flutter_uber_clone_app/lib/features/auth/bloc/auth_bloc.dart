import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_uber_clone_app/utils/api/api_manager.dart';
import 'package:flutter_uber_clone_app/utils/api/api_req_endpoints.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {

    on<UserLoginEvent>(userLoginEvent);
  }

  FutureOr<void> userLoginEvent(UserLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final result = await ApiManager.post(ApiReqEndpoints.getUserLogin(), {
        'email': event.email,
        'password': event.password,
      });
      AppLogger.d(result);
      if (result['status'] == 200) {
        emit(NavigateToHomeScreen());
      } else {
        emit(AuthFailureState(message: result['message']));
      }
    } catch (e) {
      AppLogger.e(e);
    }
  }
}
