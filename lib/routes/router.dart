import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
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
          final role = state.pathParameters['role'] ?? 'student';
          return LoginPageByRole(role: role);
        },
      ),
      GoRoute(
        path: '/student-home',
        name: RoutesNames.homestudent,
        builder: (context, state) => const StudentHome(),
      ),
      GoRoute(
        path: '/teacher-dashboard',
        name: RoutesNames.teacherdash,
        builder: (context, state) => const TeacherDashboard(),
      ),
      GoRoute(
        path: '*',
        builder: (context, state) => const NotFoundPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authState is AuthLoginSuccess;
      final isGoingToAuth = state.matchedLocation == '/' || 
                           state.matchedLocation == '/select-role' || 
                           state.matchedLocation.startsWith('/login');

      if (!isAuthenticated && !isGoingToAuth) {
        return '/';
      }

      if (isAuthenticated && isGoingToAuth) {
        switch (authState.role) {
          case 'teacher':
            return '/teacher-dashboard';
          case 'student':
            return '/student-home';
          default:
            return '/select-role';
        }
            }

      return null;
    },
  );
}