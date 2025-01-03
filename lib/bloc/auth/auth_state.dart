
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String role;
  final num userId;

  AuthLoginSuccess({
    required this.role, 
    required this.userId,
  });

  @override
  List<Object?> get props => [role, userId];
}

class AuthLogoutSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}