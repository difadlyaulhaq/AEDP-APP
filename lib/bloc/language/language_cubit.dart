import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

class LanguageInitialState extends LanguageState {
  LanguageInitialState() : super(const Locale('en'));
}

class LanguageChangedState extends LanguageState {
  const LanguageChangedState(super.locale);
}

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'selected_language';
  final SharedPreferences _prefs;

  LanguageCubit(this._prefs) : super(LanguageInitialState()) {
    // Load saved language when cubit is created
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    final savedLanguage = _prefs.getString(_languageKey);
    if (savedLanguage != null) {
      emit(LanguageChangedState(Locale(savedLanguage)));
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    // Save language preference
    await _prefs.setString(_languageKey, locale.languageCode);
    // Emit new state
    emit(LanguageChangedState(locale));
  }
}
