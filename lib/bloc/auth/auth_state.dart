part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthSignupSuccess extends AuthState {  // Define this class
  final String message;  // You can add more properties if needed

  AuthSignupSuccess({required this.message}); // Constructor
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthLoginSuccess extends AuthState {
  final String role;

  AuthLoginSuccess({required this.role});
}
