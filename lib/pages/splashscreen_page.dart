import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    Future.delayed(const Duration(seconds: 3), () {
      context.go('/select-role');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            Text(
              "Al Farooq Center:",
              style: blackColorTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              "Omar Bin Al Khattab School",
              style: blackColorTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
