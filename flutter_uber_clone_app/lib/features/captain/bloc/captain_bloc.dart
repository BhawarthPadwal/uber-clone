import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'captain_event.dart';
part 'captain_state.dart';

class CaptainBloc extends Bloc<CaptainEvent, CaptainState> {
  CaptainBloc() : super(CaptainInitial()) {
    on<OpenBottomSheetOnUserRideReqEvent>(openBottomSheetOnUserRideReqEvent);
  }

  FutureOr<void> openBottomSheetOnUserRideReqEvent(OpenBottomSheetOnUserRideReqEvent event, Emitter<CaptainState> emit) {
    emit(OpenBottomSheetOnUserRideReqState());
  }
}
