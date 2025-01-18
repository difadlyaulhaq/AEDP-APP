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
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    return MultiProvider(
      providers: [
        // Tambahkan Provider untuk FirebaseFirestore di awal
        Provider<FirebaseFirestore>.value(
          value: firestore,
        ),
        // Kemudian diikuti dengan MultiBlocProvider
        Provider<AuthBloc>.value(value: authBloc),
        Provider<SharedPreferences>.value(value: prefs),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<LanguageCubit>(create: (_) => LanguageCubit(prefs)),
          BlocProvider<LoadProfileBloc>(
            create: (context) => LoadProfileBloc(context.read<FirebaseFirestore>()),
            lazy: false,
          ),
          BlocProvider<ScheduleBloc>(
            create: (context) => ScheduleBloc(firestore: context.read<FirebaseFirestore>()),
            lazy: false,
          ),
          BlocProvider<MaterialBloc>(create: (_) => MaterialBloc()),
        ],
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
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
      ),
    );
  }
}