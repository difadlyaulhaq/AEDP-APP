import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/generated/l10n.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LanguageCubit>();

    return DropdownButton<String>(
      value: Localizations.localeOf(context).languageCode,
      icon: const Icon(Icons.language, color: Colors.blue),
      underline: const SizedBox(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          cubit.changeLanguage(Locale(newValue));
        }
      },
      items: [
        DropdownMenuItem(
          value: 'en',
          child: Text(S.of(context).language_english,
              style: const TextStyle(color: Colors.black)),
        ),
        DropdownMenuItem(
          value: 'pt',
          child: Text(S.of(context).language_portuguese,
              style: const TextStyle(color: Colors.black)),
        ),
        DropdownMenuItem(
          value: 'ar',
          child: Text(S.of(context).language_arabic,
              style: const TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
