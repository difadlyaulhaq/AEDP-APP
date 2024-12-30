import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String role;
  final String email;

  AuthLoginSuccess({required this.role, required this.email});

  @override
  List<Object?> get props => [role, email];
}
class AuthLogoutState extends AuthState {}
class AuthLogoutSuccess extends AuthState{}
class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}