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

abstract class RoutesNames {
  static const splash = 'splash';
  static const selectRole = 'selectRole';
  static const login = 'login';
  static const studentHome = 'studentHome';
  static const teacherDashboard = 'teacherDashboard';
}

GoRouter getRouter(AuthState authState) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: RoutesNames.splash,
        builder: (context, state) => const Splashscreen(),
      ),
      GoRoute(
        path: '/select-role',
        name: RoutesNames.selectRole,
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
        name: RoutesNames.studentHome,
        builder: (context, state) => const StudentHome(),
      ),
      GoRoute(
        path: '/teacher-dashboard',
        name: RoutesNames.teacherDashboard,
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

      // If not authenticated and not going to auth page, redirect to splash
      if (!isAuthenticated && !isGoingToAuth) {
        return '/';
      }

      // If authenticated and going to auth page, redirect to appropriate dashboard
      if (isAuthenticated && isGoingToAuth) {
        if (authState is AuthLoginSuccess) {
          if (authState.role == 'teacher') {
            return '/teacher-dashboard';
          } else if (authState.role == 'student') {
            return '/student-home';
          }
        }
      }

      return null;
    },
  );
}