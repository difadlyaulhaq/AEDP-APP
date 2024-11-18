import 'package:go_router/go_router.dart';
import 'package:project_aedp/pages/students/student_home.dart';
import 'package:project_aedp/pages/teacher/teacher_dashboard.dart';
import '../pages/loginbyrole.dart';
import '../pages/notfound.dart';
import '../pages/selectrole.dart';
import '../pages/sign_up_page.dart';
import '../pages/splashscreen_page.dart';

part 'router_name.dart';

abstract class RoutesNames {
  static const splash = 'splash';
  static const selectRole = 'selectRole';
  static const login = 'login';
  static const signup = 'signup';
  static const studentHome = 'studentHome';
  static const teacherDashboard = 'teacherDashboard';
}

final router = GoRouter(
  routes: [
    // Splashscreen Route
    GoRoute(
      path: '/',
      name: RoutesNames.splash,
      builder: (context, state) => const Splashscreen(),
    ),

    // Select Role Route
    GoRoute(
      path: '/select-role',
      name: RoutesNames.selectRole,
      builder: (context, state) => const LoginScreen(),
    ),

    // Login Page with Role Route
    GoRoute(
      path: '/login/:role',
      name: RoutesNames.login,
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return LoginPageByRole(role: role);
      },
    ),

    // Signup Page with Role Route
    GoRoute(
      path: '/signup/:role',
      name: RoutesNames.signup,
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return SignupPageByRole(role: role);
      },
    ),

    // Student Home Route
    GoRoute(
      path: '/student-home',
      name: RoutesNames.studentHome,
      builder: (context, state) => const StudentHome(),
    ),

    // Teacher Dashboard Route
    GoRoute(
      path: '/teacher-dashboard',
      name: RoutesNames.teacherDashboard,
      builder: (context, state) => const TeacherDashboard(),
    ),

    // 404 Not Found Route
    GoRoute(
      path: '*',
      builder: (context, state) => const NotFoundPage(), // A page you define for 404 errors
    ),
  ],
);
