import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/firebase_options.dart';
import 'package:project_aedp/pages/selectrole.dart';
import 'package:project_aedp/pages/students/dashboard_students.dart';
import 'package:project_aedp/pages/teacher/teacher_dashboard.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _uploadScheduleData();

  final authRepository = AuthRepository(FirebaseFirestore.instance);
  final authBloc = AuthBloc(authRepository: authRepository);
  final firestore = FirebaseFirestore.instance; // Create an instance of FirebaseFirestore
  final List<String> roles = ['student', 'parent', 'teacher'];

  runApp(MyApp(authBloc: authBloc, roles: roles, firestore: firestore)); // Pass firestore instance
}

Future<void> _uploadScheduleData() async {
  final firestore = FirebaseFirestore.instance;
  final scheduleData = {
    'Monday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Math', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
    ],
    'Tuesday': [
      {'subject': 'Science', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'History', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
    ],
  };

  for (final day in scheduleData.keys) {
    final docSnapshot = await firestore.collection('schedules').doc(day).get();
    if (!docSnapshot.exists) {
      await firestore.collection('schedules').doc(day).set({'schedule': scheduleData[day]});
    }
  }
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final List<String> roles;
  final FirebaseFirestore firestore; // Add firestore to the constructor

  const MyApp({super.key, required this.authBloc, required this.roles, required this.firestore});

  @override
  Widget build(BuildContext context) {
    authBloc.add(AuthLoadLoginStatus()); // Check login status on startup

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => authBloc),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
        BlocProvider<LoadProfileBloc>(create: (_) => LoadProfileBloc(firestore)), // Pass firestore instance here
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: BlocProvider.of<LanguageCubit>(context).state.locale ?? const Locale('en'),
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[100],
            ),
            builder: (context, child) {
              if (authState is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (authState is AuthLoginSuccess) {
                if (authState.role == 'teacher') {
                  return const TeacherDashboard();
                } else if (authState.role == 'student') {
                  return const DashboardStudents();
                }
              }
              return LoginScreen();
            },
          );
        },
      ),
    );
  }
}
