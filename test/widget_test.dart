import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/pages/select_role/loginbyrole.dart';

void main() async {
  // Initialize Firebase before running tests
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  group('LoginPageByRole Tests', () {
    testWidgets('Test LoginPageByRole with BottomNavigationBar', (WidgetTester tester) async {
      final authRepository = AuthRepository(FirebaseFirestore.instance);
      final authBloc = AuthBloc(authRepository: authRepository);
      final roles = ['student', 'parent', 'teacher'];

      // Wrap the widget with a MaterialApp and Scaffold for BottomNavigationBar context
      await tester.pumpWidget(
        BlocProvider<AuthBloc>(
          create: (_) => authBloc,
          child: MaterialApp(
            home: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                ],
              ),
              body: LoginPageByRole(role: roles[0]), // Your widget with a role
            ),
          ),
        ),
      );

      // Ensure all animations (like navigation) are settled
      await tester.pumpAndSettle();

      // Now verify the presence of the LoginPageByRole widget
      expect(find.byType(LoginPageByRole), findsOneWidget);

      // You can also check the BottomNavigationBar if needed
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    // Additional tests can go here
  });
}
