import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'auth_repository.dart';
import 'dart:developer' as dev;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
  on<AuthLogoutRequested>((event, emit) async {
    try {
      dev.log('Processing logout request');
      emit(AuthLoading());
      await authRepository.clearLoginStatus();
      emit(AuthLogoutSuccess());
      dev.log('Logout successful');
    } catch (e) {
      dev.log('Logout failed: $e');
      emit(AuthFailure('Failed to logout: ${e.toString()}'));
    }
  });

        on<AuthLoadLoginStatus>((event, emit) async {
          emit(AuthLoading());
          try {
            final prefs = await SharedPreferences.getInstance();
            final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
            final role = prefs.getString('role');
            final userId = prefs.getString('userId');
            dev.log('Loading login status - isLoggedIn: $isLoggedIn, Role: $role, UserId: $userId');
            if (isLoggedIn && role != null && userId != null) {
              dev.log('Auto-login: Role: $role, UserId: $userId');
              emit(AuthLoginSuccess(role: role, userId: num.parse(userId)));      
              } else {
              dev.log('No existing login session');
              emit(AuthInitial());
            }
          } catch (e) {
            dev.log('Error loading login status: $e');
            emit(AuthFailure(e.toString()));
          }
        });
      on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        dev.log('Processing login request - ID: ${event.id}, Role: ${event.role}');

        // Pastikan ID dikonversi ke tipe konsisten (misalnya, double)
        final loginResult = await authRepository.logIn(
          id: event.id,
          password: event.password,
        );

        if (loginResult != null) {
          final userRole = loginResult['role'] as String;
          final userId = loginResult['userId'] as num;

          dev.log('Login successful - Retrieved Role: $userRole, UserId: $userId');

          if (userRole.toLowerCase() != event.role.toLowerCase()) {
            dev.log('Role mismatch - Expected: ${event.role}, Got: $userRole');
            emit(AuthFailure('Access denied: incorrect role'));
            return;
          }

          await authRepository.saveLoginStatus(userId, userRole);
          dev.log('Login status saved successfully');

          emit(AuthLoginSuccess(role: userRole, userId: userId));
        } else {
          dev.log('Login failed - Invalid credentials');
          emit(AuthFailure('Invalid credentials'));
        }
      } catch (e) {
        dev.log('Login error: $e');
        emit(AuthFailure(e.toString()));
      }
    });
  }
}