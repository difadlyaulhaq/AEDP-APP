part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String role;

  SignupEvent({
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

class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String role; // Include the role if needed

   AuthSignupRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  List<Object?> get props => [email, password, confirmPassword, role];
}