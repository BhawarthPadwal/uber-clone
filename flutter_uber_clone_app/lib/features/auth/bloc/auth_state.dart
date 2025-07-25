part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

sealed class AuthActionableState extends AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthSuccessState extends AuthActionableState {
  final String message;

  AuthSuccessState({required this.message});
}

final class AuthFailureState extends AuthActionableState {
  final String message;

  AuthFailureState({required this.message});
}

final class AuthLoadingState extends AuthActionableState {}

final class NavigateToUserLoginScreenState extends AuthActionableState {}

final class NavigateToUserSignUpScreenState extends AuthActionableState {}

final class NavigateToCaptainLoginScreenState extends AuthActionableState {}

final class NavigateToCaptainSignUpScreenState extends AuthActionableState {}

final class NavigateToUserHomeScreen extends AuthActionableState {}

final class NavigateToCaptainHomeScreen extends AuthActionableState {}
