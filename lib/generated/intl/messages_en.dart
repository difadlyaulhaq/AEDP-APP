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

  static String m0(errorMessage) => "Error: ${errorMessage}";

  static String m1(errorMessage) => "Login failed: ${errorMessage}";

  static String m2(role) => "Login as ${role}";

  static String m3(role) => "${role} Login";

  static String m4(role) => "Signup as ${role}";

  static String m5(date) => "Due ${date}, 23:59";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthLoginRequested": MessageLookupByLibrary.simpleMessage(
            "Authenticating login request"),
        "accessDeniedIncorrectRole": MessageLookupByLibrary.simpleMessage(
            "Access denied: Incorrect role."),
        "accessDeniedMessage": MessageLookupByLibrary.simpleMessage(
            "Access denied: Incorrect role."),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "art": MessageLookupByLibrary.simpleMessage("Art"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "contact": MessageLookupByLibrary.simpleMessage("Contact"),
        "dashboard_attendance":
            MessageLookupByLibrary.simpleMessage("Attendance"),
        "dashboard_grades": MessageLookupByLibrary.simpleMessage("Grades"),
        "dashboard_materials":
            MessageLookupByLibrary.simpleMessage("Materials"),
        "dashboard_notifications":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "dashboard_reports": MessageLookupByLibrary.simpleMessage("Reports"),
        "dashboard_schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
        "dashboard_todo_header": MessageLookupByLibrary.simpleMessage("To-Do:"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "errorLabel": m0,
        "filterSubjects":
            MessageLookupByLibrary.simpleMessage("Filter Subjects"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
        "geography": MessageLookupByLibrary.simpleMessage("Geography"),
        "hello": MessageLookupByLibrary.simpleMessage("Hello"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address."),
        "invalidEmailMessage": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address."),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "language_english": MessageLookupByLibrary.simpleMessage("English"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("Portuguese"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
        "loginFailedMessage": m1,
        "loginPrompt": MessageLookupByLibrary.simpleMessage(
            "Login to your account to continue"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
            "Login to your account to continue"),
        "login_as_role": m2,
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "math": MessageLookupByLibrary.simpleMessage("Math"),
        "music": MessageLookupByLibrary.simpleMessage("Music"),
        "nameNotFound": MessageLookupByLibrary.simpleMessage("Name not found"),
        "nav_attendance": MessageLookupByLibrary.simpleMessage("Attendance"),
        "nav_home": MessageLookupByLibrary.simpleMessage("Home"),
        "nav_profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "noProfileData":
            MessageLookupByLibrary.simpleMessage("No profile data found."),
        "noScheduleAvailable":
            MessageLookupByLibrary.simpleMessage("No schedule available"),
        "parent": MessageLookupByLibrary.simpleMessage("Parent"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordRequirement": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters."),
        "pleaseEnterEmailAndPassword": MessageLookupByLibrary.simpleMessage(
            "Please enter your email and password"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "roleHeader": m3,
        "role_parent": MessageLookupByLibrary.simpleMessage("Parent"),
        "role_student": MessageLookupByLibrary.simpleMessage("Student"),
        "role_teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "scheduleTitle": MessageLookupByLibrary.simpleMessage("Schedule"),
        "science": MessageLookupByLibrary.simpleMessage("Science"),
        "select_role": MessageLookupByLibrary.simpleMessage("Select Role"),
        "select_your_role":
            MessageLookupByLibrary.simpleMessage("Select your role"),
        "shortPasswordMessage": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters."),
        "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signup_as_role": m4,
        "student": MessageLookupByLibrary.simpleMessage("Student"),
        "subjectsTitle": MessageLookupByLibrary.simpleMessage("Subjects"),
        "teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "todo_assignment1_title":
            MessageLookupByLibrary.simpleMessage("Assignment 1"),
        "todo_due_date": m5,
        "todo_due_today":
            MessageLookupByLibrary.simpleMessage("Due today, 23:59"),
        "todo_online_learning4":
            MessageLookupByLibrary.simpleMessage("Online Learning #04"),
        "todo_online_learning5":
            MessageLookupByLibrary.simpleMessage("Online Learning #05"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "unknownRole": MessageLookupByLibrary.simpleMessage("Unknown role"),
        "unknownRoleMessage":
            MessageLookupByLibrary.simpleMessage("Unknown role"),
        "userInfo": MessageLookupByLibrary.simpleMessage("User Information"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome to the app!")
      };
}
