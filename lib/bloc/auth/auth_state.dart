part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignupSuccess extends AuthState {
  final String message;

  AuthSignupSuccess({required this.message});
}

class AuthLoginSuccess extends AuthState {
  final String role;

  AuthLoginSuccess({required this.role});
}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}
