import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
class AuthLoadLoginStatus extends AuthEvent {}
class AuthLogoutRequested extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
     on<AuthLogoutRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepository.clearLoginStatus();
        emit(AuthLogoutSuccess()); // Using new state for logout success
      } catch (e) {
        print('Logout error: $e');
        emit(AuthFailure('Failed to logout: ${e.toString()}'));
      }
    });
    on<AuthLoadLoginStatus>((event, emit) async {
      emit(AuthLoading());
      try {
        final loginStatus = await authRepository.loadLoginStatus();
        if (loginStatus != null) {
          emit(AuthLoginSuccess(
            role: loginStatus['role']!,
            email: loginStatus['email']!,
          ));
        } else {
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userRole = await authRepository.logIn(
          email: event.email,
          password: event.password,
        );
        
        if (userRole != null) {
          print('Login successful, role: $userRole');
          // Pastikan urutan parameter sesuai dengan method di AuthRepository
          await authRepository.saveLoginStatus(event.email, userRole);
          
          // Add small delay to ensure state is properly updated
          await Future.delayed(const Duration(milliseconds: 100));
          
          // Verifikasi role yang login dengan role yang diminta
          if (userRole.toLowerCase() != event.role.toLowerCase()) {
            emit(AuthFailure('Access denied: incorrect role'));
            return;
          }
          
          emit(AuthLoginSuccess(role: userRole, email: event.email));
        } else {
          print('Login failed: Invalid credentials');
          emit(AuthFailure('Invalid credentials'));
        }
      } catch (e) {
        print('Login error: $e');
        emit(AuthFailure(e.toString()));
      }
    });
  }
}