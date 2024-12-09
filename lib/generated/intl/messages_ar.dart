// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(role) => "تسجيل الدخول كـ ${role}";

  static String m1(role) => "إنشاء حساب كـ ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "hello": MessageLookupByLibrary.simpleMessage("مرحبًا"),
        "language": MessageLookupByLibrary.simpleMessage("اللغة"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "language_english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("البرتغالية"),
        "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "login_as_role": m0,
        "parent": MessageLookupByLibrary.simpleMessage("والد/والدة"),
        "role_parent": MessageLookupByLibrary.simpleMessage("والد"),
        "role_student": MessageLookupByLibrary.simpleMessage("طالب"),
        "role_teacher": MessageLookupByLibrary.simpleMessage("معلم"),
        "select_role": MessageLookupByLibrary.simpleMessage("اختيار الدور"),
        "select_your_role": MessageLookupByLibrary.simpleMessage("اختر دورك"),
        "signup": MessageLookupByLibrary.simpleMessage("التسجيل"),
        "signup_as_role": m1,
        "student": MessageLookupByLibrary.simpleMessage("طالب"),
        "teacher": MessageLookupByLibrary.simpleMessage("معلم"),
        "welcome": MessageLookupByLibrary.simpleMessage("مرحبًا بك في التطبيق!")
      };
}
