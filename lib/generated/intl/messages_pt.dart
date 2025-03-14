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

  static String m0(grade) => "Turma: ${grade}";

  static String m1(path) => "Baixado para ${path}";

  static String m2(errorMessage) => "Erro: ${errorMessage}";

  static String m3(name) => "Inserir notas para ${name}";

  static String m4(errorMessage) => "Falha no login: ${errorMessage}";

  static String m5(role) => "Entrar como ${role}";

  static String m6(role) => "Login de ${role}";

  static String m7(id) => "ID da Escola: ${id}";

  static String m8(role) => "Registrar como ${role}";

  static String m9(date) => "Vence em ${date}, 23:59";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthLoginRequested": MessageLookupByLibrary.simpleMessage(
            "Solicitação de login em autenticação"),
        "accessDeniedIncorrectRole": MessageLookupByLibrary.simpleMessage(
            "Acesso negado: Função incorreta."),
        "accessDeniedMessage": MessageLookupByLibrary.simpleMessage(
            "Acesso negado: Função incorreta."),
        "address": MessageLookupByLibrary.simpleMessage("Endereço"),
        "administrativeFee":
            MessageLookupByLibrary.simpleMessage("Taxa Administrativa"),
        "administrative_fee":
            MessageLookupByLibrary.simpleMessage("Taxa administrativa"),
        "all": MessageLookupByLibrary.simpleMessage("Todos"),
        "appTitle": MessageLookupByLibrary.simpleMessage(
            "Página de Notas do Professor"),
        "arabic": MessageLookupByLibrary.simpleMessage("Árabe"),
        "art": MessageLookupByLibrary.simpleMessage("Arte"),
        "assignment1": MessageLookupByLibrary.simpleMessage("Tarefa 1"),
        "assignment_1": MessageLookupByLibrary.simpleMessage("Tarefa 1"),
        "assignment_1_due":
            MessageLookupByLibrary.simpleMessage("Vencimento hoje, 23:59"),
        "attendance_tracking":
            MessageLookupByLibrary.simpleMessage("Acompanhamento de Presença"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "cancelLabel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "certificates": MessageLookupByLibrary.simpleMessage("Certificados"),
        "class1": m0,
        "classes": MessageLookupByLibrary.simpleMessage("Turma:"),
        "classesAssigned":
            MessageLookupByLibrary.simpleMessage("Turmas Atribuídas:"),
        "contact": MessageLookupByLibrary.simpleMessage("Contato"),
        "contact_school_id":
            MessageLookupByLibrary.simpleMessage("Contato / ID da Escola"),
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
        "dateOfBirth":
            MessageLookupByLibrary.simpleMessage("Data de Nascimento"),
        "download": MessageLookupByLibrary.simpleMessage("Baixar"),
        "downloadLabel": MessageLookupByLibrary.simpleMessage("Baixar"),
        "downloadedTo": m1,
        "due_oct_16": MessageLookupByLibrary.simpleMessage(
            "Vence em 16 de outubro, 23.59"),
        "due_oct_9": MessageLookupByLibrary.simpleMessage(
            "Vence em 9 de outubro, 23.59"),
        "due_today": MessageLookupByLibrary.simpleMessage("Vence hoje, 23.59"),
        "e_library": MessageLookupByLibrary.simpleMessage("Biblioteca Digital"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "english": MessageLookupByLibrary.simpleMessage("Inglês"),
        "enterGrade":
            MessageLookupByLibrary.simpleMessage("Insira a nota (0-100)"),
        "enterGradeValue":
            MessageLookupByLibrary.simpleMessage("Insira a nota (0-20)"),
        "enterGrades": MessageLookupByLibrary.simpleMessage("Inserir Notas"),
        "error": MessageLookupByLibrary.simpleMessage("Ocorreu um erro"),
        "errorLabel": m2,
        "evenSemester": MessageLookupByLibrary.simpleMessage("Semestre Par"),
        "fatherName": MessageLookupByLibrary.simpleMessage("Nome do Pai"),
        "fee_payment_management": MessageLookupByLibrary.simpleMessage(
            "Gerenciamento de Pagamento de Taxas"),
        "filterSubjects":
            MessageLookupByLibrary.simpleMessage("Filtrar Disciplinas"),
        "firstPeriod": MessageLookupByLibrary.simpleMessage("Primeiro Período"),
        "fullName": MessageLookupByLibrary.simpleMessage("Nome completo"),
        "geography": MessageLookupByLibrary.simpleMessage("Geografia"),
        "gpa": MessageLookupByLibrary.simpleMessage("Média"),
        "grade": MessageLookupByLibrary.simpleMessage("Nota"),
        "gradeClass": MessageLookupByLibrary.simpleMessage("Série/Classe"),
        "gradeValidation": MessageLookupByLibrary.simpleMessage(
            "A nota deve estar entre 0-20"),
        "grades": MessageLookupByLibrary.simpleMessage("Notas"),
        "gradesUploaded":
            MessageLookupByLibrary.simpleMessage("Notas Enviadas"),
        "grades_title": MessageLookupByLibrary.simpleMessage("Suas Notas"),
        "hello": MessageLookupByLibrary.simpleMessage("Olá"),
        "history": MessageLookupByLibrary.simpleMessage("História"),
        "home": MessageLookupByLibrary.simpleMessage("Início"),
        "inputGrades": m3,
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Por favor, insira um endereço de e-mail válido."),
        "invalidEmailMessage": MessageLookupByLibrary.simpleMessage(
            "Por favor, insira um endereço de email válido."),
        "invoice": MessageLookupByLibrary.simpleMessage("Fatura"),
        "invoiceTitle": MessageLookupByLibrary.simpleMessage("2023/2024"),
        "invoice_even": MessageLookupByLibrary.simpleMessage("Par"),
        "invoice_odd": MessageLookupByLibrary.simpleMessage("Ímpar"),
        "invoice_title": MessageLookupByLibrary.simpleMessage("Fatura"),
        "invoices": MessageLookupByLibrary.simpleMessage("Faturas"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("Árabe"),
        "language_english": MessageLookupByLibrary.simpleMessage("Inglês"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("Português"),
        "list_of_subjects":
            MessageLookupByLibrary.simpleMessage("Lista de matérias"),
        "loading": MessageLookupByLibrary.simpleMessage("Carregando..."),
        "loadingLabel":
            MessageLookupByLibrary.simpleMessage("Carregando biblioteca..."),
        "login": MessageLookupByLibrary.simpleMessage("Entrar"),
        "loginButton": MessageLookupByLibrary.simpleMessage("Entrar"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Falha no login"),
        "loginFailedMessage": m4,
        "loginPrompt": MessageLookupByLibrary.simpleMessage(
            "Faça login na sua conta para continuar"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
            "Faça login na sua conta para continuar"),
        "login_as_role": m5,
        "logout": MessageLookupByLibrary.simpleMessage("Sair"),
        "materials": MessageLookupByLibrary.simpleMessage("Materiais"),
        "math": MessageLookupByLibrary.simpleMessage("Matemática"),
        "maxGrade20":
            MessageLookupByLibrary.simpleMessage("O valor máximo da nota é 20"),
        "maxGradeValue": MessageLookupByLibrary.simpleMessage("Nota Máxima"),
        "mother_name": MessageLookupByLibrary.simpleMessage("Nome da Mãe"),
        "music": MessageLookupByLibrary.simpleMessage("Música"),
        "nameNotFound":
            MessageLookupByLibrary.simpleMessage("Nome não encontrado"),
        "nav_attendance": MessageLookupByLibrary.simpleMessage("Presença"),
        "nav_dashboard":
            MessageLookupByLibrary.simpleMessage("Painel de Controle"),
        "nav_home": MessageLookupByLibrary.simpleMessage("Início"),
        "nav_invoice": MessageLookupByLibrary.simpleMessage("Fatura"),
        "nav_notifications":
            MessageLookupByLibrary.simpleMessage("Notificações"),
        "nav_profile": MessageLookupByLibrary.simpleMessage("Perfil"),
        "noFilesAvailable":
            MessageLookupByLibrary.simpleMessage("Nenhum arquivo disponível."),
        "noProfileData": MessageLookupByLibrary.simpleMessage(
            "Nenhum dado de perfil encontrado."),
        "noScheduleAvailable": MessageLookupByLibrary.simpleMessage(
            "Nenhum cronograma disponível"),
        "noStudents":
            MessageLookupByLibrary.simpleMessage("Nenhum aluno encontrado"),
        "noSubjects":
            MessageLookupByLibrary.simpleMessage("Nenhuma matéria disponível"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notificações"),
        "oddSemester": MessageLookupByLibrary.simpleMessage("Semestre Ímpar"),
        "online_learning_04":
            MessageLookupByLibrary.simpleMessage("Aprendizado Online #04"),
        "online_learning_04_due": MessageLookupByLibrary.simpleMessage(
            "Vencimento 9 de Outubro, 23:59"),
        "online_learning_05":
            MessageLookupByLibrary.simpleMessage("Aprendizado Online #05"),
        "online_learning_05_due": MessageLookupByLibrary.simpleMessage(
            "Vencimento 16 de Outubro, 23:59"),
        "online_learning_4":
            MessageLookupByLibrary.simpleMessage("Aprendizagem Online #04"),
        "online_learning_5":
            MessageLookupByLibrary.simpleMessage("Aprendizagem Online #05"),
        "openSettings":
            MessageLookupByLibrary.simpleMessage("Abrir Configurações"),
        "parent": MessageLookupByLibrary.simpleMessage("Pai/Mãe"),
        "parentInfo":
            MessageLookupByLibrary.simpleMessage("Informações do Responsável"),
        "parent_dashboard":
            MessageLookupByLibrary.simpleMessage("Painel dos Pais"),
        "password": MessageLookupByLibrary.simpleMessage("Senha"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("Senha"),
        "passwordRequirement": MessageLookupByLibrary.simpleMessage(
            "A senha deve ter pelo menos 6 caracteres."),
        "placeOfBirth":
            MessageLookupByLibrary.simpleMessage("Local de Nascimento"),
        "pleaseEnterEmailAndPassword": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال البريد الإلكتروني وكلمة المرور"),
        "previouslyGraded":
            MessageLookupByLibrary.simpleMessage("Avaliado Anteriormente"),
        "profile": MessageLookupByLibrary.simpleMessage("Perfil"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("Perfil"),
        "reports": MessageLookupByLibrary.simpleMessage("Relatórios"),
        "roleHeader": m6,
        "schedule": MessageLookupByLibrary.simpleMessage("Agenda"),
        "scheduleTitle": MessageLookupByLibrary.simpleMessage("Cronograma"),
        "schoolId": m7,
        "science": MessageLookupByLibrary.simpleMessage("Ciência"),
        "secondPeriod": MessageLookupByLibrary.simpleMessage("Segundo Período"),
        "select_role": MessageLookupByLibrary.simpleMessage("Escolher o papel"),
        "select_your_role":
            MessageLookupByLibrary.simpleMessage("Selecione o seu papel"),
        "semester_even": MessageLookupByLibrary.simpleMessage("Par"),
        "semester_odd": MessageLookupByLibrary.simpleMessage("Ímpar"),
        "shortPasswordMessage": MessageLookupByLibrary.simpleMessage(
            "A senha deve ter pelo menos 6 caracteres."),
        "signup": MessageLookupByLibrary.simpleMessage("Cadastrar-se"),
        "signup_as_role": m8,
        "student": MessageLookupByLibrary.simpleMessage("Estudante"),
        "studentDetails":
            MessageLookupByLibrary.simpleMessage("Detalhes do Aluno"),
        "studentInfo":
            MessageLookupByLibrary.simpleMessage("Informações do Aluno"),
        "studentName": MessageLookupByLibrary.simpleMessage("Nome do Aluno"),
        "student_dashboard":
            MessageLookupByLibrary.simpleMessage("Painel do Aluno"),
        "student_progress_monitoring": MessageLookupByLibrary.simpleMessage(
            "Monitoramento do Progresso do Aluno"),
        "subject": MessageLookupByLibrary.simpleMessage("Matéria"),
        "subject_arabic": MessageLookupByLibrary.simpleMessage("Árabe"),
        "subject_art": MessageLookupByLibrary.simpleMessage("Arte"),
        "subject_english": MessageLookupByLibrary.simpleMessage("Inglês"),
        "subject_history": MessageLookupByLibrary.simpleMessage("História"),
        "subject_list_title":
            MessageLookupByLibrary.simpleMessage("Lista de Disciplinas"),
        "subject_math": MessageLookupByLibrary.simpleMessage("Matemática"),
        "subject_physical_education":
            MessageLookupByLibrary.simpleMessage("Educação Física"),
        "subject_science": MessageLookupByLibrary.simpleMessage("Ciência"),
        "subjectsTitle": MessageLookupByLibrary.simpleMessage("Disciplinas"),
        "submitGrades": MessageLookupByLibrary.simpleMessage("Enviar Notas"),
        "teacher": MessageLookupByLibrary.simpleMessage("Professor"),
        "teacherInfo":
            MessageLookupByLibrary.simpleMessage("Informações do Professor"),
        "teacherSchedule":
            MessageLookupByLibrary.simpleMessage("Horário do Professor"),
        "teacher_dashboard":
            MessageLookupByLibrary.simpleMessage("Painel do Professor"),
        "teacher_input_grades": MessageLookupByLibrary.simpleMessage(
            "Página de Entrada de Notas do Professor"),
        "thirdPeriod": MessageLookupByLibrary.simpleMessage("Terceiro Período"),
        "todo": MessageLookupByLibrary.simpleMessage("Tarefas:"),
        "todo_assignment1_title":
            MessageLookupByLibrary.simpleMessage("Tarefa 1"),
        "todo_due_date": m9,
        "todo_due_today":
            MessageLookupByLibrary.simpleMessage("Vence hoje, 23:59"),
        "todo_online_learning4":
            MessageLookupByLibrary.simpleMessage("Aprendizado Online #04"),
        "todo_online_learning5":
            MessageLookupByLibrary.simpleMessage("Aprendizado Online #05"),
        "todo_title": MessageLookupByLibrary.simpleMessage("A Fazer:"),
        "transcript": MessageLookupByLibrary.simpleMessage("Transcrição"),
        "tuitionFee": MessageLookupByLibrary.simpleMessage("Taxa de Matrícula"),
        "tuition_fee":
            MessageLookupByLibrary.simpleMessage("Taxa de matrícula"),
        "unknown": MessageLookupByLibrary.simpleMessage("Desconhecido"),
        "unknownRole":
            MessageLookupByLibrary.simpleMessage("Função desconhecida"),
        "unknownRoleMessage":
            MessageLookupByLibrary.simpleMessage("Função desconhecida"),
        "uploading": MessageLookupByLibrary.simpleMessage("Enviando..."),
        "userInfo":
            MessageLookupByLibrary.simpleMessage("Informações do Usuário"),
        "viewGrades": MessageLookupByLibrary.simpleMessage("Ver Notas"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bem-vindo ao aplicativo!"),
        "whatsapp": MessageLookupByLibrary.simpleMessage("WhatsApp"),
        "year": MessageLookupByLibrary.simpleMessage("Ano"),
        "your_grades": MessageLookupByLibrary.simpleMessage("Suas notas")
      };
}
