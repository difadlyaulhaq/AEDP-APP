import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:project_aedp/bloc/teacher_materi/material_event.dart';
import 'package:project_aedp/bloc/teacher_materi/teacher_bloc.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';

import 'package:project_aedp/firebase_options.dart';
import 'package:project_aedp/routes/router.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Upload default schedule data to Firestore
  await _uploadScheduleData();

  runApp(const MyApp());
}

// Function to upload default schedule data to Firestore if not already uploaded
Future<void> _uploadScheduleData() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Map<String, List<Map<String, String>>> scheduleData = {
    'Monday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Math', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '10:40 - 12:20', 'class': 'Class 6.2.1'},
    ],
    'Tuesday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Math', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '10:40 - 12:20', 'class': 'Class 6.2.1'},
    ],
    'Wednesday': [
      {'subject': 'Math', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
    ],
    'Thursday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
    ],
    'Friday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
    ],
  };

  for (final entry in scheduleData.entries) {
    final day = entry.key;
    final schedule = entry.value;

    final docSnapshot = await firestore.collection('schedules').doc(day).get();

    if (!docSnapshot.exists) {
      await firestore.collection('schedules').doc(day).set({
        'schedule': schedule,
      });
      debugPrint('$day successfully uploaded.');
    } else {
      debugPrint('$day already in Firestore, upload skipped.');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> subjects = ['English', 'Math', 'Science']; // Define subjects list here

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(FirebaseFirestore.instance),
          ),
        ),
        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider<ScheduleBloc>(
          create: (context) => ScheduleBloc(firestore: FirebaseFirestore.instance),
        ),
        BlocProvider<MaterialBloc>(
          create: (context) => MaterialBloc()..add(FetchMaterials(subjects: subjects)),  // Corrected event dispatch
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'AEDP',
            locale: state is LanguageChangedState ? state.locale : const Locale('en'),
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
              }
              return supportedLocales.first;
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
          );
        },
      ),
    ); 
  }
}
