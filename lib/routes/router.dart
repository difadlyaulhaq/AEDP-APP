import 'package:go_router/go_router.dart';
import '../pages/homepage.dart';
import '../pages/login_page.dart';
import '../pages/sign_up_page.dart';
import '../pages/splashscreen_page.dart';
part 'router_name.dart';
final router = GoRouter(
  routes:[
    GoRoute(
      path: '/',
      name: Routesnames.splash,
      builder: (context, state) => const Splashscreen(),
    ),
    GoRoute(
      path: '/Login',
      name: Routesnames.login,
      builder: (context, state) => const LoginPage(),   
    ),
    GoRoute(
      path:'/signup',
      name: Routesnames.signup,
      builder: (context, state) => const SignupPage(), 
      ),
    GoRoute(
      path: '/home',
      name: Routesnames.home,
      builder: (context, state) => const HomePage(),
    )
  ]
);