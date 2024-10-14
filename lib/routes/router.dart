import 'package:go_router/go_router.dart';
import '../pages/homepage.dart';
import '../pages/selectrole.dart';
import '../pages/sign_up_page.dart';
import '../pages/splashscreen_page.dart';

part 'router_name.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: Routesnames.splash,
      builder: (context, state) => const Splashscreen(),
    ),
    GoRoute(
      path: '/select-role',
      name: Routesnames.selectrole,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/login/:role', // Add a parameter in the path
      name: Routesnames.login,
      builder: (context, state) {
        final role = state.pathParameters['role']!; // Get the 'role' from the route parameters
        return LoginPageByRole(role: role); // Pass the role to the LoginPageByRole
      },
    ),
    GoRoute(
        path: '/signup/:role', // Menambahkan parameter role
        name: Routesnames.signup,
        builder: (context, state) {
          final role = state.pathParameters['role']!; // Ambil parameter role dari URL
          return SignupPageByRole(role: role); // Pass role ke halaman SignupPageByRole
        },
      ),
    GoRoute(
      path: '/home',
      name: Routesnames.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
