import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/routes/router.dart';
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
            // Navigate to the home page after signup
            context.go(Routesnames.home);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signup failed: ${state.message}')),
            );
          }
        },
        child: Center(
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
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: bluecolor,
                ),
              ),
              Text(
                "Create an account to continue",
                style: bluecolorTextstyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              // Email TextField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
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
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
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
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
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
                width: 290,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Trigger the signup event
                    context.read<AuthBloc>().add(AuthSignupRequested(
                            email: emailController.text,
                            password: passwordController.text,
                            role: role,
                          ));

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
