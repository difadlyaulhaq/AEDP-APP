import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
            on<SignupEvent>((event, emit) async {
          emit(AuthLoading());
          try {
            await authRepository.signUp(
              email: event.email,
              password: event.password,
              role: event.role,
            );
            emit(AuthSuccess());
          } catch (e) {
            emit(AuthFailure(e.toString())); // Pass the message here
          }
        });

        on<LoginEvent>((event, emit) async {
          emit(AuthLoading());
          try {
            final role = await authRepository.logIn(
              email: event.email,
              password: event.password,
            );
            if (role != null) {
              emit(AuthLoginSuccess(role: role));
            } else {
              emit(AuthFailure('Role not found')); // Pass the message here
            }
          } catch (e) {
            emit(AuthFailure(e.toString())); // Pass the message here
          }
        });

  }
}
