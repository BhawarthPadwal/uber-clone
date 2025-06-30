import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'captain_event.dart';
part 'captain_state.dart';

class CaptainBloc extends Bloc<CaptainEvent, CaptainState> {
  CaptainBloc() : super(CaptainInitial()) {
    on<CaptainEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
