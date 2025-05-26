import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/widget/dropdown/language_dropdown.dart';
import 'package:project_aedp/widget/dropdown/role_dropdown.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> roles = ['student', 'parent', 'teacher'];
  String selectedLoginRole = 'student';

  void navigateToLogin(String role) {
    dev.log("Navigating to login page with role: $role");
    if (mounted) context.go('/login/$role');
  }

  @override
  Widget build(BuildContext context) {
    dev.log("LoginScreen build called. Current role: $selectedLoginRole");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: const [LanguageDropdown()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 150),
            const SizedBox(height: 30),
            Text(
              S.of(context).select_your_role,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: Directionality.of(context) == TextDirection.rtl
                  ? TextAlign.right
                  : TextAlign.left,
            ),
            const SizedBox(height: 10),
            RoleDropdown(
              roles: roles,
              selectedRole: selectedLoginRole,
              onChanged: (role) {
                if (role != null) {
                  setState(() => selectedLoginRole = role);
                  navigateToLogin(role);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    dev.log("Disposing LoginScreen");
    super.dispose();
  }
}
