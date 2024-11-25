import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../theme/theme.dart'; // Assuming your theme is defined here

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
            // Navigate based on the role after login success
            switch (role) {
              case 'Login as Student':
                context.go('/student-home');
                break;
              case 'Login as Parent':
                context.go('/parent-home');
                break;
              case 'Login as Teacher':
                context.go('/teacher-dashboard');
                break;
              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unknown role')),
                );
                break;
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: ${state.errorMessage}')),
            );
          }
        },
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            shrinkWrap: true,
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
                "Login to your account to continue",
                textAlign: TextAlign.center,
                style: bluecolorTextstyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(emailController, "Email", Icons.email),
              _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),

              const SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid email address.')),
                      );
                      return;
                    }

                    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password must be at least 6 characters.')),
                      );
                      return;
                    }

                    // Dispatch login event
                    context.read<AuthBloc>().add(
                      AuthLoginRequested(
                        email: emailController.text,
                        password: passwordController.text,
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
                    'Login',
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

  /// Helper method to build a text field
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: bluecolor,
        label: Text(
          label,
          style: whiteColorTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        prefixIcon: Icon(icon, color: whiteColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
