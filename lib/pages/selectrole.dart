import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:project_aedp/theme/theme.dart';
import '../routes/router.dart'; // Make sure your router is imported

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedLoginRole = 'Login Student'; // Default selected value for login dropdown
  List<String> loginRoles = ['Login Student', 'Login Parent', 'Login Teacher']; // Login dropdown options

  String selectedSignupRole = 'Signup Student'; // Default selected value for signup dropdown
  List<String> signupRoles = ['Signup Student', 'Signup Parent', 'Signup Teacher']; // Signup dropdown options

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
                icon: Icon(Icons.keyboard_arrow_down_outlined, color: whiteColor),
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
                icon: Icon(Icons.keyboard_arrow_down_outlined, color: bluecolor),
                isExpanded: true,
                dropdownColor: Colors.white,
                underline: const SizedBox(),
                style: TextStyle(color: bluecolor, fontSize: 18),
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 132,
              height: 131,
            ),
            const SizedBox(height: 12),
            Text(
              role,
              style: bluecolorTextstyle.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "Login to continue using the app",
              style: bluecolorTextstyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              child: TextField(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              child: TextField(
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
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: 290,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  router.goNamed(Routesnames.home); // Go to home page after login
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
          ],
        ),
      ),
    );
  }
}
