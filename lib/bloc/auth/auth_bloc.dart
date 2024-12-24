import 'package:bloc/bloc.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';

// New event for loading login status
class AuthLoadLoginStatus extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Handle login event
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final role = await authRepository.logIn(
          email: event.email,
          password: event.password,
        );
        if (role != null) {
          emit(AuthLoginSuccess(role: role, email: event.email)); // Pass email here
        } else {
          emit(AuthFailure('Login failed: Invalid credentials.'));
        }
      } catch (e) {
        emit(AuthFailure('Login failed: ${e.toString()}'));
      }
    });

    // Handle loading login status
    on<AuthLoadLoginStatus>((event, emit) async {
      emit(AuthLoading());
      try {
        final loginStatus = await authRepository.loadLoginStatus();
        if (loginStatus != null) {
          emit(AuthLoginSuccess(role: loginStatus['role']!, email: loginStatus['email']!)); // Add email here
        } else {
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthFailure('Failed to load login status: ${e.toString()}'));
      }
    });

    // Handle logout event
    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.clearLoginStatus(); // Clear login status
        emit(AuthInitial()); // Reset to initial state
      } catch (e) {
        emit(AuthFailure('Logout failed: ${e.toString()}'));
      }
    });
  }
}
