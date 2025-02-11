
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/pages/parrents/parrent_home.dart';
import 'package:project_aedp/pages/students/student_home.dart';
import 'package:project_aedp/pages/teacher/teacher_dashboard.dart';
import '../pages/loginbyrole.dart';
import '../pages/notfound.dart';
import '../pages/selectrole.dart';
import '../pages/splashscreen_page.dart';

part 'router_name.dart';

GoRouter getRouter(AuthState authState) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: RoutesNames.splash,
        builder: (context, state) => const Splashscreen(),
      ),
      GoRoute(
        path: '/select-role',
        name: RoutesNames.selectrole,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/login/:role',
        name: RoutesNames.login,
        builder: (context, state) {
          final role = state.pathParameters['role']!;
          return LoginPageByRole(role: role);
        },
      ),
      GoRoute(
        path: '/student-home',
        name: RoutesNames.homestudent,
        builder: (context, state) => const StudentHome(),
        redirect: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthLoginSuccess || 
              authState.role.toLowerCase() != 'student') {
            return '/select-role';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/parent-home',
        name: RoutesNames.ParrentHome,
        builder: (context, state) => const ParrentHome(),
        redirect: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthLoginSuccess || 
              authState.role.toLowerCase() != 'parent') {
            return '/select-role';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/teacher-dashboard',
        builder: (context, state) => const TeacherDashboard(),
        redirect: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthLoginSuccess || 
              authState.role.toLowerCase() != 'teacher') {
            return '/select-role';
          }
          return null;
        },
      ),
      GoRoute(
        path: '*',
        builder: (context, state) => const NotFoundPage(),
      ),
    ],
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isLoggingIn = state.matchedLocation.startsWith('/login');
    final isSelectingRole = state.matchedLocation == '/select-role';
    
    if (authState is AuthLoginSuccess) {
      if (isLoggingIn || isSelectingRole) {
        switch (authState.role.toLowerCase()) {
          case 'teacher':
            return '/teacher-dashboard';
          case 'student':
            return '/student-home';
          case 'parent':
            return '/parent-home';
          default:
            return '/select-role';
        }
      }
    } else if (!isSelectingRole && !isLoggingIn) {
      return '/select-role';
    }
    
    return null;
  },
  );
}