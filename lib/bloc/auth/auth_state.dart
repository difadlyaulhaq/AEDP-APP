part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

final class AuthStateLogin extends AuthState{}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthSignupSuccess extends AuthState {} // Add this line

class AuthLoginSuccess extends AuthState {
  final String role;
  AuthLoginSuccess({required this.role});
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
