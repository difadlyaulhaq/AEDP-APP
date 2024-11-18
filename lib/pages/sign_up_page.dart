import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/theme/theme.dart';

class SignupPageByRole extends StatelessWidget {
  final String role;

  const SignupPageByRole({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
  if (state is AuthSignupSuccess) {
    print("Signup successful, navigating to the home page for role: $role"); // Debug log

    // Redirect based on the role after successful signup
    switch (role) {
      case 'Student':
        context.go('/student-home');
        break;
      case 'Parent':
        context.go('/parentHomePage');
        break;
      case 'Teacher':
        context.go('/teacher-dashboard');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unknown role')),
        );
        break;
    }
  } else if (state is AuthFailure) {
    // Show error message on signup failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signup failed: ${state.errorMessage}')),
    );
  }
},
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            shrinkWrap: true, // Makes ListView adapt to its content size
            children: [
              const SizedBox(height: 40),
              Image.asset(
                "assets/logo.png",
                width: 132,
                height: 131,
              ),
              const SizedBox(height: 12),
              Text(
                role,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: bluecolor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Create an account to continue",
                textAlign: TextAlign.center,
                style: bluecolorTextstyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Email TextField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: bluecolor,
                    label: Text(
                      "Email",
                      style: whiteColorTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    prefixIcon: Icon(Icons.email, color: whiteColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              // Password TextField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: bluecolor,
                    label: Text(
                      "Password",
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

              // Confirm Password TextField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: bluecolor,
                    label: Text(
                      "Confirm Password",
                      style: whiteColorTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: whiteColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // Signup Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Dispatch signup event to Bloc
                    context.read<AuthBloc>().add(
                          AuthSignupRequested(
                            email: emailController.text,
                            password: passwordController.text,
                            // confirmPassword: confirmPasswordController.text,
                            role: role,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bluecolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Signup',
                    style: whiteColorTextStyle.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
