// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:project_aedp/bloc/auth/auth_bloc.dart';
// import 'package:project_aedp/theme/theme.dart';

// import '../bloc/auth/auth_event.dart';
// import '../bloc/auth/auth_state.dart';
// class SignupPageByRole extends StatelessWidget {
//   final String role;

//   const SignupPageByRole({super.key, required this.role});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();
//     final confirmPasswordController = TextEditingController();

//     return Scaffold(
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthSignupSuccess) {
//             // Redirect based on the role after successful signup
//             switch (role) {
//               case 'Signup as Student':
//                 context.go('/student-home');
//                 break;
//               case 'Signup as Parent':
//                 context.go('/parent-home');
//                 break;
//               case 'Signup as Teacher':
//                 context.go('/teacher-dashboard');
//                 break;
//               default:
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Unknown role')),
//                 );
//                 break;
//             }
//           } else if (state is AuthFailure) {
//             // Show error message on signup failure
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Signup failed: ${state.errorMessage}')),
//             );
//           }
//         },
//         child: Center(
//           child: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 60),
//             shrinkWrap: true,
//             children: [
//               const SizedBox(height: 40),
//               Image.asset(
//                 "assets/logo.png",
//                 width: 132,
//                 height: 131,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 role,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: bluecolor,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Create an account to continue",
//                 textAlign: TextAlign.center,
//                 style: bluecolorTextstyle.copyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               _buildTextField(emailController, "Email", Icons.email),
//               _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
//               _buildTextField(confirmPasswordController, "Confirm Password", Icons.lock_outline, isPassword: true),

//               const SizedBox(height: 26),

//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Validate email and password
//                     if (emailController.text.isEmpty || !emailController.text.contains('@')) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Please enter a valid email address.')),
//                       );
//                       return;
//                     }

//                     if (passwordController.text.isEmpty || passwordController.text.length < 6) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Password must be at least 6 characters.')),
//                       );
//                       return;
//                     }

//                     if (passwordController.text != confirmPasswordController.text) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Passwords do not match.')),
//                       );
//                       return;
//                     }

//                     // Dispatch signup event to Bloc
//                     context.read<AuthBloc>().add(
//                       AuthSignupRequested(
//                         email: emailController.text,
//                         password: passwordController.text,
//                         role: role,
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: bluecolor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     'Signup',
//                     style: whiteColorTextStyle.copyWith(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: bluecolor,
//           label: Text(
//             label,
//             style: whiteColorTextStyle.copyWith(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           prefixIcon: Icon(icon, color: whiteColor),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//         ),
//       ),
//     );
//   }
// }
