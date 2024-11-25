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
        await authRepository.signUp(email: event.email, role: event.role);
        emit(AuthSignupSuccess(message: 'Signup successful. OTP has been sent to your email.'));
      } catch (e) {
        emit(AuthFailure('Signup failed: ${e.toString()}'));
      }
    });

    // Handle login
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final role = await authRepository.logIn(email: event.email);
        if (role != null) {
          emit(AuthLoginSuccess(role: role));
        } else {
          emit(AuthFailure('Login failed: Email is not verified.'));
        }
      } catch (e) {
        emit(AuthFailure('Login failed: ${e.toString()}'));
      }
    });

    // Handle OTP verification
    on<AuthVerifyOTPRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.verifyOTP(email: event.email, otp: event.otp);
        emit(AuthOTPVerificationSuccess(message: 'OTP verified successfully.'));
      } catch (e) {
        emit(AuthFailure('OTP verification failed: ${e.toString()}'));
      }
    });
  }
}
