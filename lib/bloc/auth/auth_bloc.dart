import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Handling signup event
    on<AuthSignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Attempt to sign up the user with provided credentials
        await authRepository.signUp(
          email: event.email,
          password: event.password,
          role: event.role, // Ensure 'role' is passed
        );
        // Emit success state after successful signup
        emit(AuthSignupSuccess(message: 'Signup successful'));
      } catch (e) {
        // Emit failure state in case of an error
        emit(AuthFailure(e.toString()));
      }
    });
    
    // Handling login event
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Attempt to log in the user with provided credentials
        final role = await authRepository.logIn(
          email: event.email,
          password: event.password,
        );

        // Check if the role is valid and emit the corresponding state
        if (role != null) {
          emit(AuthLoginSuccess(role: role));
        } else {
          // If no role is found, emit failure state
          emit(AuthFailure('Role not found'));
        }
      } catch (e) {
        // Emit failure state in case of an error
        emit(AuthFailure(e.toString()));
      }
    });
  
  } 
}
