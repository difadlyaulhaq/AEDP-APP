import 'package:bloc/bloc.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Handle signup
    on<AuthSignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(
          email: event.email,
          password: event.password,
          role: event.role,
        );
        emit(AuthSignupSuccess(message: 'Signup successful.'));
      } catch (e) {
        emit(AuthFailure('Signup failed: ${e.toString()}'));
      }
    });

    // Handle login
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final role = await authRepository.logIn(
          email: event.email,
          password: event.password,
        );
        if (role != null) {
          emit(AuthLoginSuccess(role: role));
        } else {
          emit(AuthFailure('Login failed: Invalid credentials.'));
        }
      } catch (e) {
        emit(AuthFailure('Login failed: ${e.toString()}'));
      }
    });
  }
}
