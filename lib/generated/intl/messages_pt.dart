// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt';

  static String m0(role) => "Entrar como ${role}";

  static String m1(role) => "Registrar como ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "hello": MessageLookupByLibrary.simpleMessage("Olá"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("Árabe"),
        "language_english": MessageLookupByLibrary.simpleMessage("Inglês"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("Português"),
        "login": MessageLookupByLibrary.simpleMessage("Entrar"),
        "login_as_role": m0,
        "parent": MessageLookupByLibrary.simpleMessage("Pai/Mãe"),
        "select_role": MessageLookupByLibrary.simpleMessage("Escolher o papel"),
        "select_your_role":
            MessageLookupByLibrary.simpleMessage("Selecione o seu papel"),
        "signup": MessageLookupByLibrary.simpleMessage("Cadastrar-se"),
        "signup_as_role": m1,
        "student": MessageLookupByLibrary.simpleMessage("Estudante"),
        "teacher": MessageLookupByLibrary.simpleMessage("Professor"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bem-vindo ao aplicativo!")
      };
}
