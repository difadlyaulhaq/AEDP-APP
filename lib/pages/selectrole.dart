import 'dart:developer' as dev;
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
  String selectedLoginRole = 'student';

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
  if (mounted) {
    context.go('/login/$role');
    dev.log("Navigation requested to: /login/$role");
  }
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
                if (role != null) {
                  dev.log("Role selected: $role");
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
  // Build language dropdown
  Widget _buildLanguageDropdown(BuildContext context, LanguageCubit cubit) {
    return DropdownButton<String>(
      value: Localizations.localeOf(context).languageCode,
      icon: const Icon(Icons.language, color: Colors.blue),
      underline: const SizedBox(),
      onChanged: (String? newValue) {
        dev.log("Language selection changed to: $newValue");
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
}) {
  final textDirection = ui.TextDirection.rtl == Directionality.of(context)
      ? TextAlign.right
      : TextAlign.left;

  return Container(
    width: 250,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
    ),
    child: DropdownButton<String>(
      value: selectedRole,
      icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
      isExpanded: true,
      underline: const SizedBox(),
      style: const TextStyle(color: Colors.white, fontSize: 18),
      dropdownColor: Colors.white,
    onChanged: (String? role) {
  if (role != null) {
    dev.log("Role selected: $role");
    setState(() {
      selectedLoginRole = role;
    });
    navigateToLogin(role); // Gunakan fungsi navigasi yang sudah ada
  }
},      items: roles.map((String role) {
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


  @override
  void dispose() {
    dev.log("Disposing LoginScreen");
    super.dispose();
  }
}