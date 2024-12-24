import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignupSuccess extends AuthState {
  final String message;

  AuthSignupSuccess({required this.message});
}

class AuthOTPVerificationSuccess extends AuthState {
  final String message;

  AuthOTPVerificationSuccess({required this.message});
  
  List<Object?> get props => [message];
}

class AuthLoginSuccess extends AuthState {
  final String role;

  AuthLoginSuccess({required this.role});
}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}

