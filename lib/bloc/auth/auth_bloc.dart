import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLogoutRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepository.clearLoginStatus();
        emit(AuthLogoutSuccess());
      } catch (e) {
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
            userId: loginStatus['userId']!,
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
        final loginResult = await authRepository.logIn(
          id: event.id,
          password: event.password,
        );
        
        if (loginResult != null) {
          final userRole = loginResult['role'] as String;
          final userId = loginResult['userId'] as num;
          
          await authRepository.saveLoginStatus(userId, userRole);
          
          if (userRole.toLowerCase() != event.role.toLowerCase()) {
            emit(AuthFailure('Access denied: incorrect role'));
            return;
          }
          
          emit(AuthLoginSuccess(role: userRole, userId: userId));
        } else {
          emit(AuthFailure('Invalid credentials'));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}