abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final num id;
  final String password;
  final String role;

  AuthLoginRequested({
    required this.id,
    required this.password,
    required this.role,
  });
}

class AuthLogoutRequested extends AuthEvent {}

class AuthLoadLoginStatus extends AuthEvent {}