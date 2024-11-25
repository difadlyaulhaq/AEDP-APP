import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class AuthSignupRequested extends AuthEvent {
  final String email;
  final String role;
  final String password;

  AuthSignupRequested({
    required this.email,
    required this.role,
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

class AuthVerifyOTPRequested extends AuthEvent {
  final String email;
  final String otp;

  AuthVerifyOTPRequested({
    required this.email,
    required this.otp,
  });
}
