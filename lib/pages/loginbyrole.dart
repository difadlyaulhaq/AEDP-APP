import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import 'package:project_aedp/generated/l10n.dart';
import '../bloc/auth/auth_state.dart';

class LoginPageByRole extends StatefulWidget {
  final String role;

  const LoginPageByRole({super.key, required this.role});

  @override
  State<LoginPageByRole> createState() => _LoginPageByRoleState();
}

class _LoginPageByRoleState extends State<LoginPageByRole> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
   final localization = S.of(context);

    return WillPopScope(
    onWillPop: () async {
    
      context.go('/select-role');
      return false; // Mencegah pop default
    },
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              if (state.role != widget.role.toLowerCase()) {
                _showSnackBar(S.of(context).accessDeniedIncorrectRole);
                return;
              }
      
              switch (state.role) {
                case 'student':
                  context.go('/student-home');
                  break;
                case 'parent':
                  context.go('/parent-home');
                  break;
                case 'teacher':
                  context.go('/teacher-dashboard');
                  break;
                default:
                  _showSnackBar(localization.unknownRole);
                  break;
              }
            } else if (state is AuthFailure) {
              _showSnackBar('${localization.loginFailed}: ${state.errorMessage}');
            }
          },
          child: Center(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              shrinkWrap: true,
              children: [
                const SizedBox(height: 40),
                Image.asset("assets/logo.png", width: 132, height: 131),
                const SizedBox(height: 12),
                Text(widget.role, textAlign: TextAlign.center, style: _headerStyle()),
                const SizedBox(height: 8),
                Text(localization.loginPrompt, textAlign: TextAlign.center, style: _subHeaderStyle()),
                const SizedBox(height: 20),
                _buildTextField(emailController, localization.email, Icons.email),
                const SizedBox(height: 12),
                _buildPasswordField(localization.password),
                const SizedBox(height: 26),
                _buildActionButton(localization.login, () {
                  if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                    _showSnackBar(localization.invalidEmail);
                    return;
                  }
                  if (passwordController.text.isEmpty || passwordController.text.length < 6) {
                    _showSnackBar(localization.passwordRequirement);
                    return;
                  }
                  context.read<AuthBloc>().add(AuthLoginRequested(
                        email: emailController.text,
                        password: passwordController.text,
                        role: widget.role,
                      ));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return TextField(
      controller: passwordController,
      obscureText: isPasswordObscured,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(isPasswordObscured ? Icons.visibility : Icons.visibility_off),
          onPressed: _togglePasswordVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  TextStyle _headerStyle() => const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue);
  TextStyle _subHeaderStyle() => const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey);
}
