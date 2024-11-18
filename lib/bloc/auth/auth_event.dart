part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String role; // Ensure 'role' is required

  AuthSignupRequested({
    required this.email,
    required this.password,
    required this.role,
  });
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;

  AuthLoginRequested({
    required this.email,
    required this.password,
    required this.role,
  });
}
