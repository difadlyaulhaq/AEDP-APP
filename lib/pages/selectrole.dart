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
  // Roles for login and signup
  final List<String> loginRoles = ['student', 'parent', 'teacher'];
  final List<String> signupRoles = ['student', 'parent', 'teacher'];

  String selectedLoginRole = 'student'; // Default value for login
  String selectedSignupRole = 'student'; // Default value for signup

  // Localized role text for the dropdown
  String localizedRoleText(BuildContext context, String role) {
    switch (role) {
      case 'student':
        return S.of(context).role_student;
      case 'parent':
        return S.of(context).role_parent;
      case 'teacher':
        return S.of(context).role_teacher;
      default:
        return S.of(context).role_student; // Default fallback
    }
  }

  // Login as role text with localized role
// Login as role text with localized role
String loginAsRoleText(BuildContext context, String role) {
  final String template = S.of(context).login_as_role(role); // Call the function to get the string
  return template.replaceFirst("{role}", localizedRoleText(context, role)); // Replace placeholder with actual role
}

// Signup as role text with localized role
String signupAsRoleText(BuildContext context, String role) {
  final String template = S.of(context).signup_as_role(role); // Call the function to get the string
  return template.replaceFirst("{role}", localizedRoleText(context, role)); // Replace placeholder with actual role
}


  // Navigate to login page based on role
  void _navigateToLoginPage(String role) {
    context.go('/login/$role');
  }

  // Navigate to signup page based on role
  void _navigateToSignupPage(String role) {
    context.go('/signup/$role');
  }

  @override
  Widget build(BuildContext context) {
    final languageCubit = context.read<LanguageCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          DropdownButton<String>(
            value: Localizations.localeOf(context).languageCode,
            icon: const Icon(Icons.language, color: Colors.blue),
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                languageCubit.changeLanguage(Locale(newValue));
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
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png', // Replace with your actual image path
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30),

            // Localized text below the logo
            Text(
              S.of(context).select_your_role,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 90),
                  child: Text(
                    S.of(context).login,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Login Dropdown button
            _buildRoleDropdown(
              context: context,
              label: loginAsRoleText(context, selectedLoginRole), // Pass the correct arguments here
              roles: loginRoles,
              selectedRole: selectedLoginRole,
              color: Colors.blue,
              textColor: Colors.white,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedLoginRole = newValue;
                  });
                  _navigateToLoginPage(newValue);
                }
              },
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 90),
                  child: Text(
                    S.of(context).signup,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 10),
            // Signup Dropdown button
            _buildRoleDropdown(
              context: context,
              label: signupAsRoleText(context, selectedSignupRole), // Pass the correct arguments here
              roles: signupRoles,
              selectedRole: selectedSignupRole,
              color: Colors.white,
              textColor: Colors.blue,
              borderColor: Colors.blue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedSignupRole = newValue;
                  });
                  _navigateToSignupPage(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleDropdown({
    required BuildContext context,
    required String label,
    required List<String> roles,
    required String selectedRole,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required ValueChanged<String?> onChanged,
  }) {
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
        dropdownColor: Colors.white,
        underline: const SizedBox(),
        style: TextStyle(color: textColor, fontSize: 18),
        onChanged: onChanged,
        items: roles.map<DropdownMenuItem<String>>((String role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(
              localizedRoleText(context, role), // Display localized role text
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}
