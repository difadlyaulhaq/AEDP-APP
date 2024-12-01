import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
List<String> loginRoles = ['student', 'parent', 'teacher'];
List<String> signupRoles = ['student', 'parent', 'teacher'];

String selectedLoginRole = 'student'; // Default value for login
String selectedSignupRole = 'student'; // Default value for signup

  // Navigate to login page based on role
  void _navigateToLoginPage(String role) {
  context.go('/login/$role'); // Role is now 'student', 'parent', or 'teacher'
}

void _navigateToSignupPage(String role) {
  context.go('/signup/$role'); // Role is now 'student', 'parent', or 'teacher'
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your actual image path
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30),

            // Login Dropdown button
            Container(
              width: 250,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue,
              ),
              child: DropdownButton<String>(
              value: selectedLoginRole,
              icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
              isExpanded: true,
              dropdownColor: Colors.white,
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLoginRole = newValue!;
                });
                _navigateToLoginPage(selectedLoginRole); // Navigate with selected role
              },
              items: loginRoles.map<DropdownMenuItem<String>>((String role) {
                return DropdownMenuItem<String>(
                  value: role, // Use standardized role value
                  child: Text(
                    'Login as ${role[0].toUpperCase()}${role.substring(1)}', // Human-readable label
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),

            ),
            const SizedBox(height: 20),

            // Signup Dropdown button
            Container(
              width: 250,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                border: Border.all(color: Colors.blue),
              ),
              child: DropdownButton<String>(
              value: selectedSignupRole,
              icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.blue),
              isExpanded: true,
              dropdownColor: Colors.white,
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.blue, fontSize: 18),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSignupRole = newValue!;
                });
                _navigateToSignupPage(selectedSignupRole); // Navigate with selected role
              },
              items: signupRoles.map<DropdownMenuItem<String>>((String role) {
                return DropdownMenuItem<String>(
                  value: role, // Use standardized role value
                  child: Text(
                    'Signup as ${role[0].toUpperCase()}${role.substring(1)}', // Human-readable label
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),

            ),
          ],
        ),
      ),
    );
  }
}
