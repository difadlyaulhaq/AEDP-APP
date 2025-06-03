import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/widget/login_widget/id_input_field.dart';
import 'package:project_aedp/widget/login_widget/password_field.dart';
import 'package:project_aedp/widget/login_widget/login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class LoginPageByRole extends StatefulWidget {
  final String role;
  const LoginPageByRole({super.key, required this.role});

  @override
  State<LoginPageByRole> createState() => _LoginPageByRoleState();
}

class _LoginPageByRoleState extends State<LoginPageByRole> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool isPasswordObscured = true;
  bool isLoading = false;
  String? loginError;

  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleLogin() {
    final idText = idController.text.trim();
    final password = passwordController.text.trim();

    if (idText.isEmpty || password.isEmpty) {
      _showSnackBar(S.of(context).enterIdAndPassword);
      return;
    }

    final id = num.tryParse(idText);
    if (id == null) {
      _showSnackBar(S.of(context).invalidNumericId);
      return;
    }

    setState(() => isLoading = true);
    context.read<AuthBloc>().add(AuthLoginRequested(id: id, password: password, role: widget.role));
  }

  void _togglePasswordObscured() {
    setState(() => isPasswordObscured = !isPasswordObscured);
  }

  Future<void> _handleAuthSuccess(String role, num? userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('role', role);
    await prefs.setString('userId', userId?.toInt().toString() ?? '');

    if (!mounted) return;

    switch (role.toLowerCase()) {
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
        _showSnackBar(S.of(context).unknownRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return WillPopScope(
      onWillPop: () async {
        context.go('/select-role');
        return false;
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${t.login} - ${widget.role}'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/select-role'),
            ),
          ),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) async {
              dev.log('Auth state: $state');
              setState(() => isLoading = state is AuthLoading);

              if (state is AuthLoginSuccess) {
                await _handleAuthSuccess(state.role, state.userId);
              } else if (state is AuthFailure) {
                setState(() => loginError = t.invalidCredentials);
              }
            },
            builder: (context, state) => _buildLoginForm(t),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(S t) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", width: 132, height: 131),
            const SizedBox(height: 12),
            Text(widget.role, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 8),
            Text(t.loginPrompt, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey)),

            const SizedBox(height: 20),
            IdInputField(
              controller: idController,
              label: t.contact_school_id,
              icon: Icons.call,
              onSubmit: _handleLogin,
            ),
            const SizedBox(height: 12),
            PasswordField(
              controller: passwordController,
              isObscured: isPasswordObscured,
              onToggle: _togglePasswordObscured,
              label: t.password,
              onSubmit: _handleLogin,
            ),
            if (loginError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(loginError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
            const SizedBox(height: 26),
            LoginButton(
              isLoading: isLoading,
              onPressed: _handleLogin,
              label: t.login,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
