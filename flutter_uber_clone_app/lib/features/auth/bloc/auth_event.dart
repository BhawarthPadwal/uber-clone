part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class VerifyTokenEvent extends AuthEvent {}

final class UserLoginEvent extends AuthEvent {
  final String email;
  final String password;

  UserLoginEvent(this.email, this.password);
}

final class CaptainLoginEvent extends AuthEvent {
  final String email;
  final String password;

  CaptainLoginEvent(this.email, this.password);
}

final class UserSignupEvent extends AuthEvent {
  final Map<String, dynamic> fullname;
  final String email;
  final String password;

  UserSignupEvent(this.fullname, this.email, this.password);
}

final class CaptainSignupEvent extends AuthEvent {
  final Map<String, dynamic> fullname;
  final String email;
  final String password;
  final Map<String, dynamic> vehicle;

  CaptainSignupEvent(this.fullname, this.email, this.password, this.vehicle);
}
