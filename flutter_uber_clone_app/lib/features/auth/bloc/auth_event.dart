part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class UserLoginEvent extends AuthEvent {
  final String email;
  final String password;
  UserLoginEvent(this.email, this.password);
}

final class SignUpNavigationEvent extends AuthEvent {}

final class CaptainLoginNavigationEvent extends AuthEvent {}

final class HomePageNavigationEvent extends AuthEvent {}
