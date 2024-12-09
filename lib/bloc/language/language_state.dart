import 'package:meta/meta.dart';
import 'dart:ui'; // Provides Locale class

@immutable
abstract class LanguageState {
  final Locale locale;
  final bool isLoading;
  final String? error;

  const LanguageState({
    required this.locale,
    this.isLoading = false,
    this.error,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LanguageState &&
              runtimeType == other.runtimeType &&
              locale == other.locale &&
              isLoading == other.isLoading &&
              error == other.error;

  @override
  int get hashCode => Object.hash(locale, isLoading, error);
}

class LanguageInitial extends LanguageState {
  const LanguageInitial({
    required super.locale,
  }) : super(
    isLoading: false,
  );
}

class LanguageLoading extends LanguageState {
  const LanguageLoading({
    required super.locale,
  }) : super(
    isLoading: true,
  );
}

class LanguageChanged extends LanguageState {
  const LanguageChanged({
    required super.locale,
  }) : super(
    isLoading: false,
  );
}

class LanguageError extends LanguageState {
  const LanguageError({
    required super.locale,
    required String super.error,
  }) : super(
    isLoading: false,
  );
}
