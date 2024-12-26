import 'dart:developer' as dev; // Tambahkan dart:developer untuk logging
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> roles = ['student', 'parent', 'teacher'];
  String selectedLoginRole = 'student'; // Properti State untuk nilai dropdown

  String getLocalizedRole(BuildContext context, String role) {
    switch (role) {
      case 'student':
        return S.of(context).role_student;
      case 'parent':
        return S.of(context).role_parent;
      case 'teacher':
        return S.of(context).role_teacher;
      default:
        return S.of(context).role_student;
    }
  }

  String getLoginAsText(BuildContext context, String role) {
    dev.log("Generating login as text for role: $role");
    return S.of(context).login_as_role(getLocalizedRole(context, role));
  }

  void navigateToLogin(String role) {
    dev.log("Navigating to login page with role: $role");
    Future.microtask(() {
      if (mounted) {
        context.go('/login/$role');
        dev.log("Navigation successful to: /login/$role");
      } else {
        dev.log("Widget not mounted. Navigation aborted.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageCubit = context.read<LanguageCubit>();
    final textDirection = ui.TextDirection.rtl == Directionality.of(context)
        ? TextAlign.right
        : TextAlign.left;

    dev.log("LoginScreen build called. Current role: $selectedLoginRole");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          _buildLanguageDropdown(context, languageCubit),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30),
            Text(
              S.of(context).select_your_role,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: textDirection,
            ),
            const SizedBox(height: 10),
            _buildRoleDropdown(
              context: context,
              label: getLoginAsText(context, selectedLoginRole),
              selectedRole: selectedLoginRole,
              onChanged: (role) {
                dev.log("Role selected: $role");
                if (role != null && role != selectedLoginRole) {
                  setState(() {
                    selectedLoginRole = role;
                    dev.log("State updated. New role: $selectedLoginRole");
                  });
                  navigateToLogin(role);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context, LanguageCubit cubit) {
    return DropdownButton<String>(
      value: Localizations.localeOf(context).languageCode,
      icon: const Icon(Icons.language, color: Colors.blue),
      underline: const SizedBox(),
      onChanged: (String? newValue) {
        dev.log("Language changed to: $newValue");
        if (newValue != null) {
          cubit.changeLanguage(Locale(newValue));
        }
      },
      items: [
        DropdownMenuItem(
          value: 'en',
          child: Text(S.of(context).language_english,
              style: const TextStyle(color: Colors.black)),
        ),
        DropdownMenuItem(
          value: 'pt',
          child: Text(S.of(context).language_portuguese,
              style: const TextStyle(color: Colors.black)),
        ),
        DropdownMenuItem(
          value: 'ar',
          child: Text(S.of(context).language_arabic,
              style: const TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown({
    required BuildContext context,
    required String label,
    required String selectedRole,
    required ValueChanged<String?> onChanged,
    Color color = Colors.blue,
    Color textColor = Colors.white,
    Color? borderColor,
  }) {
    final textDirection = ui.TextDirection.rtl == Directionality.of(context)
        ? TextAlign.right
        : TextAlign.left;

    dev.log("Building role dropdown with selected role: $selectedRole");

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color,
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: DropdownButton<String>(
        value: selectedRole,
        icon: Icon(Icons.keyboard_arrow_down_outlined, color: textColor),
        isExpanded: true,
        underline: const SizedBox(),
        style: TextStyle(color: textColor, fontSize: 18),
        onChanged: onChanged,
        items: roles.map((role) {
          dev.log("Adding role to dropdown: $role");
          return DropdownMenuItem<String>(
            value: role,
            child: Text(
              getLocalizedRole(context, role),
              textAlign: textDirection,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}
