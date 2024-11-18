import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

// Import router for navigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedLoginRole = 'Login as Student'; // Default selected value for login dropdown
  List<String> loginRoles = [
    'Login as Student',
    'Login as Parent',
    'Login as Teacher'
  ]; // Login dropdown options

  String selectedSignupRole = 'Signup as Student'; // Default selected value for signup dropdown
  List<String> signupRoles = [
    'Signup as Student',
    'Signup as Parent',
    'Signup as Teacher'
  ]; // Signup dropdown options

  // Navigate to login page based on role
  void _navigateToLoginPage(String role) {
    context.go('/login/$role'); // Include the role in the navigation
  }

  void _navigateToSignupPage(String role) {
    context.go('/signup/$role'); // Modify path and pass the role for signup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
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
                  _navigateToLoginPage(selectedLoginRole); // GoRouter navigation for login
                },
                items: loginRoles.map<DropdownMenuItem<String>>((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(
                      role,
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
                  _navigateToSignupPage(selectedSignupRole); // GoRouter navigation for signup
                },
                items: signupRoles.map<DropdownMenuItem<String>>((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(
                      role,
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