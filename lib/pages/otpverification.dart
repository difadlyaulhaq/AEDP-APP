import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';

class OTPVerificationPage extends StatelessWidget {
  final String email;
  final String role;

  const OTPVerificationPage({
    super.key,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOTPVerificationSuccess) {
            // Redirect based on the role after successful OTP verification
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
            // Show error message on OTP verification failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP verification failed: ${state.errorMessage}')),
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
                "Verify OTP for $role",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter the OTP sent to your email address",
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40),

              // OTP TextField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue,
                    label: const Text(
                      "OTP",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // Verify OTP Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Dispatch OTP verification event to Bloc
                    context.read<AuthBloc>().add(
                          AuthVerifyOTPRequested(
                            email: email,
                            otp: otpController.text,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Verify OTP',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
