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

  static String m0(errorMessage) => "Erro: ${errorMessage}";

  static String m1(errorMessage) => "Falha no login: ${errorMessage}";

  static String m2(role) => "Entrar como ${role}";

  static String m3(role) => "Login de ${role}";

  static String m4(role) => "Registrar como ${role}";

  static String m5(date) => "Vence em ${date}, 23:59";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthLoginRequested": MessageLookupByLibrary.simpleMessage(
            "Solicitação de login em autenticação"),
        "accessDeniedIncorrectRole": MessageLookupByLibrary.simpleMessage(
            "Acesso negado: Função incorreta."),
        "accessDeniedMessage": MessageLookupByLibrary.simpleMessage(
            "Acesso negado: Função incorreta."),
        "all": MessageLookupByLibrary.simpleMessage("Todos"),
        "arabic": MessageLookupByLibrary.simpleMessage("Árabe"),
        "art": MessageLookupByLibrary.simpleMessage("Arte"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "contact": MessageLookupByLibrary.simpleMessage("Contato"),
        "dashboard_attendance":
            MessageLookupByLibrary.simpleMessage("Presença"),
        "dashboard_grades": MessageLookupByLibrary.simpleMessage("Notas"),
        "dashboard_materials":
            MessageLookupByLibrary.simpleMessage("Materiais"),
        "dashboard_notifications":
            MessageLookupByLibrary.simpleMessage("Notificações"),
        "dashboard_reports": MessageLookupByLibrary.simpleMessage("Relatórios"),
        "dashboard_schedule": MessageLookupByLibrary.simpleMessage("Agenda"),
        "dashboard_todo_header":
            MessageLookupByLibrary.simpleMessage("Tarefas:"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "english": MessageLookupByLibrary.simpleMessage("Inglês"),
        "errorLabel": m0,
        "filterSubjects":
            MessageLookupByLibrary.simpleMessage("Filtrar Disciplinas"),
        "fullName": MessageLookupByLibrary.simpleMessage("Nome completo"),
        "geography": MessageLookupByLibrary.simpleMessage("Geografia"),
        "hello": MessageLookupByLibrary.simpleMessage("Olá"),
        "history": MessageLookupByLibrary.simpleMessage("História"),
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
        "loginFailedMessage": m1,
        "loginPrompt": MessageLookupByLibrary.simpleMessage(
            "Faça login na sua conta para continuar"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
            "Faça login na sua conta para continuar"),
        "login_as_role": m2,
        "logout": MessageLookupByLibrary.simpleMessage("Sair"),
        "math": MessageLookupByLibrary.simpleMessage("Matemática"),
        "music": MessageLookupByLibrary.simpleMessage("Música"),
        "nameNotFound":
            MessageLookupByLibrary.simpleMessage("Nome não encontrado"),
        "nav_attendance": MessageLookupByLibrary.simpleMessage("Presença"),
        "nav_home": MessageLookupByLibrary.simpleMessage("Início"),
        "nav_profile": MessageLookupByLibrary.simpleMessage("Perfil"),
        "noProfileData": MessageLookupByLibrary.simpleMessage(
            "Nenhum dado de perfil encontrado."),
        "noScheduleAvailable": MessageLookupByLibrary.simpleMessage(
            "Nenhum cronograma disponível"),
        "parent": MessageLookupByLibrary.simpleMessage("Pai/Mãe"),
        "password": MessageLookupByLibrary.simpleMessage("Senha"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("Senha"),
        "passwordRequirement": MessageLookupByLibrary.simpleMessage(
            "A senha deve ter pelo menos 6 caracteres."),
        "pleaseEnterEmailAndPassword": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال البريد الإلكتروني وكلمة المرور"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("Perfil"),
        "roleHeader": m3,
        "scheduleTitle": MessageLookupByLibrary.simpleMessage("Cronograma"),
        "science": MessageLookupByLibrary.simpleMessage("Ciência"),
        "select_role": MessageLookupByLibrary.simpleMessage("Escolher o papel"),
        "select_your_role":
            MessageLookupByLibrary.simpleMessage("Selecione o seu papel"),
        "shortPasswordMessage": MessageLookupByLibrary.simpleMessage(
            "A senha deve ter pelo menos 6 caracteres."),
        "signup": MessageLookupByLibrary.simpleMessage("Cadastrar-se"),
        "signup_as_role": m4,
        "student": MessageLookupByLibrary.simpleMessage("Estudante"),
        "subjectsTitle": MessageLookupByLibrary.simpleMessage("Disciplinas"),
        "teacher": MessageLookupByLibrary.simpleMessage("Professor"),
        "todo_assignment1_title":
            MessageLookupByLibrary.simpleMessage("Tarefa 1"),
        "todo_due_date": m5,
        "todo_due_today":
            MessageLookupByLibrary.simpleMessage("Vence hoje, 23:59"),
        "todo_online_learning4":
            MessageLookupByLibrary.simpleMessage("Aprendizado Online #04"),
        "todo_online_learning5":
            MessageLookupByLibrary.simpleMessage("Aprendizado Online #05"),
        "unknown": MessageLookupByLibrary.simpleMessage("Desconhecido"),
        "unknownRole":
            MessageLookupByLibrary.simpleMessage("Função desconhecida"),
        "unknownRoleMessage":
            MessageLookupByLibrary.simpleMessage("Função desconhecida"),
        "userInfo":
            MessageLookupByLibrary.simpleMessage("Informações do Usuário"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bem-vindo ao aplicativo!")
      };
}
