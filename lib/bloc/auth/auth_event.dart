import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final num id;
  final String password;
  final String role;

  AuthLoginRequested({
    required this.id,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [id, password, role];
}

class AuthLoadLoginStatus extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}