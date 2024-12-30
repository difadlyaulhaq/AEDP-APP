import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_repository.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/language/language_cubit.dart';
import 'bloc/load_profile/profile_bloc.dart';
import 'bloc/teacher_materi/teacher_bloc.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _uploadScheduleData;
  final prefs = await SharedPreferences.getInstance();
  final firestore = FirebaseFirestore.instance;
  final authRepository = AuthRepository(firestore);
  final authBloc = AuthBloc(authRepository: authRepository);
  
  // Inisialisasi router di sini untuk memastikan konsistensi state
  final router = getRouter(AuthInitial());

  runApp(MyApp(
    authBloc: authBloc,
    firestore: firestore,
    router: router,
    prefs: prefs // Tambahkan router sebagai parameter
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
  final GoRouter router;  
  final SharedPreferences prefs;
  const MyApp({
    super.key,
    required this.authBloc,
    required this.firestore,
    required this.router,  
     required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit(prefs)),
        BlocProvider<LoadProfileBloc>(
          create: (_) => LoadProfileBloc(firestore),
          lazy: false,  // Inisialisasi langsung untuk memastikan state profile tersedia
        ),
        BlocProvider<ScheduleBloc>(
          create: (_) => ScheduleBloc(firestore: firestore),
          lazy: false,  // Inisialisasi langsung untuk schedule
        ),
        BlocProvider<MaterialBloc>(create: (_) => MaterialBloc()),
      ],
      child: BlocConsumer<AuthBloc, AuthState>(  // Ganti BlocBuilder dengan BlocConsumer
        listener: (context, state) {
          // Handle auth state changes yang mempengaruhi routing
          if (state is AuthLoginSuccess) {
            // Refresh router ketika auth state berubah
            router.refresh();
          }
        },
        builder: (context, authState) {
          final languageCubit = context.read<LanguageCubit>();

          return BlocBuilder<LanguageCubit, LanguageState>(
            bloc: languageCubit,
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: router, 
                locale: state.locale,
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
          );
        },
      ),
    );
  }
}