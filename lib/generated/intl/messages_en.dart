// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(role) => "Login as ${role}";

  static String m1(role) => "Signup as ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "hello": MessageLookupByLibrary.simpleMessage("Hello"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "language_english": MessageLookupByLibrary.simpleMessage("English"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("Portuguese"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "login_as_role": m0,
        "parent": MessageLookupByLibrary.simpleMessage("Parent"),
        "role_parent": MessageLookupByLibrary.simpleMessage("Parent"),
        "role_student": MessageLookupByLibrary.simpleMessage("Student"),
        "role_teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "select_role": MessageLookupByLibrary.simpleMessage("Select Role"),
        "select_your_role":
            MessageLookupByLibrary.simpleMessage("Select your role"),
        "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signup_as_role": m1,
        "student": MessageLookupByLibrary.simpleMessage("Student"),
        "teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome to the app!")
      };
}
