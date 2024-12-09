import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

abstract class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

class LanguageInitialState extends LanguageState {
  LanguageInitialState() : super(const Locale('en'));
}

class LanguageChangedState extends LanguageState {
  const LanguageChangedState(Locale locale) : super(locale);
}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitialState());

  void changeLanguage(Locale locale) {
    emit(LanguageChangedState(locale));
  }
}
