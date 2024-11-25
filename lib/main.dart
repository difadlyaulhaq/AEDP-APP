import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/firebase_options.dart';
import 'package:project_aedp/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(
              FirebaseFirestore.instance, // Pass FirebaseFirestore instance only
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router, // Ensure your router configuration is correctly set up
        title: 'AEDP', // Add a title for your app
        theme: ThemeData(
          primarySwatch: Colors.blue, // You can customize the theme
        ),
      ),
    );
  }
}
