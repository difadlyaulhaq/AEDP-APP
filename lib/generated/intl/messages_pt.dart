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

  static String m0(errorMessage) => "Falha no login: ${errorMessage}";

  static String m1(role) => "Entrar como ${role}";

  static String m2(role) => "Login de ${role}";

  static String m3(role) => "Registrar como ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthLoginRequested": MessageLookupByLibrary.simpleMessage(
            "Solicitação de login em autenticação"),
        "accessDeniedIncorrectRole": MessageLookupByLibrary.simpleMessage(
            "Acesso negado: Função incorreta."),
        "accessDeniedMessage": MessageLookupByLibrary.simpleMessage(
            "Acesso negado: Função incorreta."),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "hello": MessageLookupByLibrary.simpleMessage("Olá"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Por favor, insira um endereço de e-mail válido."),
        "invalidEmailMessage": MessageLookupByLibrary.simpleMessage(
            "Por favor, insira um endereço de email válido."),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("Árabe"),
        "language_english": MessageLookupByLibrary.simpleMessage("Inglês"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("Português"),
        "login": MessageLookupByLibrary.simpleMessage("Entrar"),
        "loginButton": MessageLookupByLibrary.simpleMessage("Entrar"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Falha no login"),
        "loginFailedMessage": m0,
        "loginPrompt": MessageLookupByLibrary.simpleMessage(
            "Faça login na sua conta para continuar"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
            "Faça login na sua conta para continuar"),
        "login_as_role": m1,
        "parent": MessageLookupByLibrary.simpleMessage("Pai/Mãe"),
        "password": MessageLookupByLibrary.simpleMessage("Senha"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("Senha"),
        "passwordRequirement": MessageLookupByLibrary.simpleMessage(
            "A senha deve ter pelo menos 6 caracteres."),
        "pleaseEnterEmailAndPassword": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال البريد الإلكتروني وكلمة المرور"),
        "roleHeader": m2,
        "select_role": MessageLookupByLibrary.simpleMessage("Escolher o papel"),
        "select_your_role":
            MessageLookupByLibrary.simpleMessage("Selecione o seu papel"),
        "shortPasswordMessage": MessageLookupByLibrary.simpleMessage(
            "A senha deve ter pelo menos 6 caracteres."),
        "signup": MessageLookupByLibrary.simpleMessage("Cadastrar-se"),
        "signup_as_role": m3,
        "student": MessageLookupByLibrary.simpleMessage("Estudante"),
        "teacher": MessageLookupByLibrary.simpleMessage("Professor"),
        "unknownRole":
            MessageLookupByLibrary.simpleMessage("Função desconhecida"),
        "unknownRoleMessage":
            MessageLookupByLibrary.simpleMessage("Função desconhecida"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bem-vindo ao aplicativo!")
      };
}
