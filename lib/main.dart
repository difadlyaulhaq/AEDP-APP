import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_repository.dart';
import 'package:project_aedp/firebase_options.dart';
import 'package:project_aedp/routes/router.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart'; // Import LanguageCubit
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart'; // Localization class generated from ARB files

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase initialization with platform-specific options
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
              FirebaseFirestore.instance, // Pass FirebaseFirestore instance
            ),
          ),
        ),
        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(), // Add LanguageCubit for language management
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          // Build MaterialApp with localization support based on the current language
          return MaterialApp.router(
            routerConfig: router, // Router configuration for handling navigation
            title: 'AEDP', // App title
            locale: state is LanguageChangedState ? state.locale : const Locale('en'), // Set locale based on LanguageCubit state
            supportedLocales: S.delegate.supportedLocales, // Supported locales from localization delegate
            localizationsDelegates: const [
              S.delegate, // Localization delegate generated from ARB files
              GlobalMaterialLocalizations.delegate, // Standard material localizations
              GlobalWidgetsLocalizations.delegate, // Standard widgets localizations
              GlobalCupertinoLocalizations.delegate, // Cupertino localizations for iOS-style components
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              // Handle locale resolution
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale; // Return matched locale
                  }
                }
              }
              return supportedLocales.first; // Default to the first supported locale
            },
            theme: ThemeData(
              primarySwatch: Colors.blue, // Set primary color for the app theme
            ),
          );
        },
      ),
    );
  }
}
