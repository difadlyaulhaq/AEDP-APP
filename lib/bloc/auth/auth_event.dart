part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;

  AuthSignupRequested({
    required this.email,
    required this.password,
    required this.role,
  });
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role; // Ensure this is defined

  AuthLoginRequested({
    required this.email,
    required this.password,
    required this.role, // Include this in the constructor
  });
}
