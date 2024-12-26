import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/firebase_options.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/routes/router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _uploadScheduleData();

  final firestore = FirebaseFirestore.instance;
  final authRepository = AuthRepository(firestore);
  final authBloc = AuthBloc(authRepository: authRepository);

  runApp(MyApp(
    authBloc: authBloc,
    firestore: firestore,
  ));
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
  final FirebaseFirestore firestore;

  const MyApp({
    super.key,
    required this.authBloc,
    required this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
        BlocProvider<LoadProfileBloc>(create: (_) => LoadProfileBloc(firestore)),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          // Get router configuration with authentication state
          final routerConfig = getRouter(authState);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: routerConfig,
            locale: context.read<LanguageCubit>().state.locale,
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
          );
        },
      ),
    );
  }
}