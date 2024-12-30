// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Please enter your email and password`
  String get pleaseEnterEmailAndPassword {
    return Intl.message(
      'Please enter your email and password',
      name: 'pleaseEnterEmailAndPassword',
      desc: '',
      args: [],
    );
  }

  /// `Select your role`
  String get select_your_role {
    return Intl.message(
      'Select your role',
      name: 'select_your_role',
      desc: '',
      args: [],
    );
  }

  /// `Login as {role}`
  String login_as_role(Object role) {
    return Intl.message(
      'Login as $role',
      name: 'login_as_role',
      desc: '',
      args: [role],
    );
  }

  /// `Signup as {role}`
  String signup_as_role(Object role) {
    return Intl.message(
      'Signup as $role',
      name: 'signup_as_role',
      desc: '',
      args: [role],
    );
  }

  /// `English`
  String get language_english {
    return Intl.message(
      'English',
      name: 'language_english',
      desc: '',
      args: [],
    );
  }

  /// `Portuguese`
  String get language_portuguese {
    return Intl.message(
      'Portuguese',
      name: 'language_portuguese',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get language_arabic {
    return Intl.message(
      'Arabic',
      name: 'language_arabic',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get role_student {
    return Intl.message(
      'Student',
      name: 'role_student',
      desc: '',
      args: [],
    );
  }

  /// `Parent`
  String get role_parent {
    return Intl.message(
      'Parent',
      name: 'role_parent',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get role_teacher {
    return Intl.message(
      'Teacher',
      name: 'role_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Select Role`
  String get select_role {
    return Intl.message(
      'Select Role',
      name: 'select_role',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get student {
    return Intl.message(
      'Student',
      name: 'student',
      desc: '',
      args: [],
    );
  }

  /// `Parent`
  String get parent {
    return Intl.message(
      'Parent',
      name: 'parent',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get teacher {
    return Intl.message(
      'Teacher',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the app!`
  String get welcome {
    return Intl.message(
      'Welcome to the app!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message(
      'Login',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmailMessage {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters.`
  String get shortPasswordMessage {
    return Intl.message(
      'Password must be at least 6 characters.',
      name: 'shortPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `{role} Login`
  String roleHeader(Object role) {
    return Intl.message(
      '$role Login',
      name: 'roleHeader',
      desc: '',
      args: [role],
    );
  }

  /// `Login to your account to continue`
  String get loginSubtitle {
    return Intl.message(
      'Login to your account to continue',
      name: 'loginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Access denied: Incorrect role.`
  String get accessDeniedMessage {
    return Intl.message(
      'Access denied: Incorrect role.',
      name: 'accessDeniedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unknown role`
  String get unknownRoleMessage {
    return Intl.message(
      'Unknown role',
      name: 'unknownRoleMessage',
      desc: '',
      args: [],
    );
  }

  /// `Login failed: {errorMessage}`
  String loginFailedMessage(Object errorMessage) {
    return Intl.message(
      'Login failed: $errorMessage',
      name: 'loginFailedMessage',
      desc: '',
      args: [errorMessage],
    );
  }

  /// `Access denied: Incorrect role.`
  String get accessDeniedIncorrectRole {
    return Intl.message(
      'Access denied: Incorrect role.',
      name: 'accessDeniedIncorrectRole',
      desc: '',
      args: [],
    );
  }

  /// `Unknown role`
  String get unknownRole {
    return Intl.message(
      'Unknown role',
      name: 'unknownRole',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account to continue`
  String get loginPrompt {
    return Intl.message(
      'Login to your account to continue',
      name: 'loginPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters.`
  String get passwordRequirement {
    return Intl.message(
      'Password must be at least 6 characters.',
      name: 'passwordRequirement',
      desc: '',
      args: [],
    );
  }

  /// `Authenticating login request`
  String get AuthLoginRequested {
    return Intl.message(
      'Authenticating login request',
      name: 'AuthLoginRequested',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
