import 'package:flutter/material.dart';

import '../routes/router.dart';
import '../theme/theme.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3),
    () {
      router.goNamed(Routesnames.login);
    },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor1,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "/assets/logo.png",
            width: 120,
            height: 120,
          ),
          Text(
            "Al Farooq Center:",
            style: blackColorTextStyle.copyWith(fontSize: 16),
          ),
          Text(
            " Omar Bin Al Khattab School",
            style: blackColorTextStyle.copyWith(fontSize: 16),
          )
        ],
      )
    );
  }
}