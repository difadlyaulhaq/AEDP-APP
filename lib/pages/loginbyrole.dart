import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
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
            // Redirect based on the role after successful login
            switch (state.role) {
              case 'Signup as Student':
                context.go('/student-home');
                break;
              case 'Parent':
                context.go('/parentHomePage');
                break;
              case 'Signup as Teacher':
                context.go('/teacher-dashboard');
                break;
              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unknown role')),
                );
                break;
            }
          } else if (state is AuthFailure) {
            // Show error message on authentication failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: ${state.errorMessage}')),
            );
          }
        },
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 60),
            children: [
              const SizedBox(height: 80),
              Image.asset("assets/logo.png", width: 132, height: 131),
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
              _buildTextField(
                controller: emailController,
                label: "email",
                icon: Icons.person,
                themeStyle: whiteColorTextStyle,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: passwordController,
                label: "password",
                icon: Icons.lock,
                themeStyle: whiteColorTextStyle,
                isPassword: true,
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Dispatch login event to Bloc
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
                    style: whiteColorTextStyle.copyWith(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build a text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextStyle themeStyle,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: bluecolor,
        label: Text(
          label,
          style: themeStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        prefixIcon: Icon(icon, color: whiteColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
