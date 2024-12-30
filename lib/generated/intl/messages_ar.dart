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

  static String m0(errorMessage) => "فشل تسجيل الدخول: ${errorMessage}";

  static String m1(role) => "تسجيل الدخول كـ ${role}";

  static String m2(role) => "تسجيل الدخول كـ ${role}";

  static String m3(role) => "إنشاء حساب كـ ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthLoginRequested":
            MessageLookupByLibrary.simpleMessage("طلب تسجيل الدخول جار التحقق"),
        "accessDeniedIncorrectRole": MessageLookupByLibrary.simpleMessage(
            "تم رفض الوصول: الدور غير صحيح."),
        "accessDeniedMessage":
            MessageLookupByLibrary.simpleMessage("تم الرفض: دور غير صحيح."),
        "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "hello": MessageLookupByLibrary.simpleMessage("مرحبًا"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال عنوان بريد إلكتروني صالح."),
        "invalidEmailMessage": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال عنوان بريد إلكتروني صالح."),
        "language": MessageLookupByLibrary.simpleMessage("اللغة"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "language_english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("البرتغالية"),
        "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "loginButton": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("فشل تسجيل الدخول"),
        "loginFailedMessage": m0,
        "loginPrompt": MessageLookupByLibrary.simpleMessage(
            "تسجيل الدخول إلى حسابك للمتابعة"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
            "قم بتسجيل الدخول إلى حسابك للمتابعة"),
        "login_as_role": m1,
        "parent": MessageLookupByLibrary.simpleMessage("والد/والدة"),
        "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordRequirement": MessageLookupByLibrary.simpleMessage(
            "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل."),
        "pleaseEnterEmailAndPassword": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال البريد الإلكتروني وكلمة المرور"),
        "roleHeader": m2,
        "role_parent": MessageLookupByLibrary.simpleMessage("والد"),
        "role_student": MessageLookupByLibrary.simpleMessage("طالب"),
        "role_teacher": MessageLookupByLibrary.simpleMessage("معلم"),
        "select_role": MessageLookupByLibrary.simpleMessage("اختيار الدور"),
        "select_your_role": MessageLookupByLibrary.simpleMessage("اختر دورك"),
        "shortPasswordMessage": MessageLookupByLibrary.simpleMessage(
            "يجب أن تكون كلمة المرور مكونة من 6 أحرف على الأقل."),
        "signup": MessageLookupByLibrary.simpleMessage("التسجيل"),
        "signup_as_role": m3,
        "student": MessageLookupByLibrary.simpleMessage("طالب"),
        "teacher": MessageLookupByLibrary.simpleMessage("معلم"),
        "unknownRole": MessageLookupByLibrary.simpleMessage("دور غير معروف"),
        "unknownRoleMessage":
            MessageLookupByLibrary.simpleMessage("دور غير معروف"),
        "welcome": MessageLookupByLibrary.simpleMessage("مرحبًا بك في التطبيق!")
      };
}
