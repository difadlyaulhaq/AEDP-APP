import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:project_aedp/theme/theme.dart';
import '../bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import this line
import '../routes/router.dart'; // Make sure your router is imported

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedLoginRole =
      'Login as Student'; // Default selected value for login dropdown
  List<String> loginRoles = [
    'Login as Student',
    'Login as Parent',
    'Login as Teacher'
  ]; // Login dropdown options

  String selectedSignupRole =
      'Signup as Student'; // Default selected value for signup dropdown
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
                color: bluecolor,
              ),
              child: DropdownButton<String>(
                value: selectedLoginRole,
                icon:
                    Icon(Icons.keyboard_arrow_down_outlined, color: whiteColor),
                isExpanded: true,
                dropdownColor: Colors.white,
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLoginRole = newValue!;
                  });
                  _navigateToLoginPage(
                      selectedLoginRole); // GoRouter navigation for login
                },
                items: loginRoles.map<DropdownMenuItem<String>>((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(
                      role,
                      style: TextStyle(
                        color: blackColor,
                      ),
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
                color: whiteColor,
                border: Border.all(color: bluecolor),
              ),
              child: DropdownButton<String>(
                value: selectedSignupRole,
                icon:
                    Icon(Icons.keyboard_arrow_down_outlined, color: bluecolor),
                isExpanded: true,
                dropdownColor: Colors.white,
                underline: const SizedBox(),
                style: TextStyle(color: bluecolor, fontSize: 18),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSignupRole = newValue!;
                  });
                  _navigateToSignupPage(
                      selectedSignupRole); // GoRouter navigation for signup
                },
                items: signupRoles.map<DropdownMenuItem<String>>((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(
                      role,
                      style: TextStyle(
                        color: blackColor,
                      ),
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

class LoginPageByRole extends StatelessWidget {
  final String role;

  const LoginPageByRole({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            // Redirect based on the role after successful login
            if (state.role == 'Student') {
              context.go('/home'); // or a specific student home page
            } else if (state.role == 'Parent') {
              context.go('/parentHomePage'); // Replace with actual route
            } else if (state.role == 'Teacher') {
              context.go('/teacherHomePage'); // Replace with actual route
            }
          } else if (state is AuthFailure) {
            // Show error message on authentication failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: ${state.message}')),
            );
          }
        },
        child: Center(
          child: ListView(
            shrinkWrap: true, // Agar ListView sesuai dengan isi
            padding: const EdgeInsets.symmetric(
                horizontal: 60), // Memberikan padding di seluruh sisi
            children: [
              const SizedBox(
                  height: 80), // Spacer untuk menggeser konten ke bawah
              Image.asset(
                "assets/logo.png",
                width: 132,
                height: 131,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  role,
                  style: bluecolorTextstyle.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Login to continue using the app",
                  style: bluecolorTextstyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bluecolor,
                  label: Text(
                    "email",
                    style: whiteColorTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  prefixIcon: Icon(Icons.person, color: whiteColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bluecolor,
                  label: Text(
                    "password",
                    style: whiteColorTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock, color: whiteColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    router.goNamed(Routesnames.home); // Navigate to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bluecolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: whiteColorTextStyle.copyWith(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Spacer at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
