import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'dart:developer' as dev;

class LoginPageByRole extends StatefulWidget {
  final String role;

  const LoginPageByRole({Key? key, required this.role}) : super(key: key);

  @override
  _LoginPageByRoleState createState() => _LoginPageByRoleState();
}

class _LoginPageByRoleState extends State<LoginPageByRole> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordObscured = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

 void _handleLogin() {
  final String idText = idController.text.trim();
  final String password = passwordController.text.trim();

  if (idText.isEmpty || password.isEmpty) {
    _showSnackBar(S.of(context).pleaseEnterEmailAndPassword);
    return;
  }

  num? id;
  try {
    double parsedId = double.parse(idText); // Parsing as double
    id = parsedId % 1 == 0 ? parsedId.toInt() : parsedId; 
  } catch (e) {
    _showSnackBar('Please enter a valid numeric ID');
    return;
  }

  setState(() => isLoading = true);
  dev.log('Attempting login for role: ${widget.role} with ID: $id');

  context.read<AuthBloc>().add(
        AuthLoginRequested(
          id: id,
          password: password,
          role: widget.role,
        ),
      );
}


  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return WillPopScope(
      onWillPop: () async {
        dev.log('Back navigation attempted, redirecting to role selection');
        context.go('/select-role');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${localization.login} - ${widget.role}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/select-role'),
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            dev.log('Auth state changed: $state');

            setState(() => isLoading = state is AuthLoading);

            if (state is AuthLoginSuccess) {
              dev.log('Login success, checking role match');
              if (state.role.toLowerCase() != widget.role.toLowerCase()) {
                dev.log('Role mismatch: ${state.role} vs ${widget.role}');
                _showSnackBar(S.of(context).accessDeniedIncorrectRole);
                return;
              }

              switch (state.role.toLowerCase()) {
                case 'student':
                  context.go('/student-home');
                  break;
                case 'teacher':
                  context.go('/teacher-dashboard');
                  break;
                case 'parent':
                  context.go('/parent-home');
                  break;
                default:
                  dev.log('Unknown role encountered: ${state.role}');
                  _showSnackBar(S.of(context).unknownRole);
              }
            } else if (state is AuthFailure) {
              dev.log('Auth failure: ${state.errorMessage}');
              _showSnackBar(
                '${localization.loginFailed}: ${state.errorMessage}',
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      width: 132,
                      height: 131,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.role,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localization.loginPrompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: idController,
                      label: localization.contact_school_id,
                      icon: Icons.call,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _buildPasswordField(localization.password),
                    const SizedBox(height: 26),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      _buildLoginButton(localization),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton(S localization) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          localization.login,
          style: const TextStyle(color: Colors.white),
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
          icon: Icon(
            isPasswordObscured ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => setState(() => isPasswordObscured = !isPasswordObscured),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onSubmitted: (_) => _handleLogin(),
    );
  }

 Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number, // Force number keyboard
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      // Add input validation to ensure only numbers
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onSubmitted: (_) => _handleLogin(),
    );
}
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
