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

  static String m0(grade) => "Class: ${grade}";

  static String m1(path) => "Downloaded to ${path}";

  static String m2(errorMessage) => "Error: ${errorMessage}";

  static String m3(name) => "Input Grades for ${name}";

  static String m4(errorMessage) => "Login failed: ${errorMessage}";

  static String m5(role) => "Login as ${role}";

  static String m6(role) => "${role} Login";

  static String m7(role) => "Signup as ${role}";

  static String m8(date) => "Due ${date}, 23:59";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthLoginRequested": MessageLookupByLibrary.simpleMessage(
            "Authenticating login request"),
        "accessDeniedIncorrectRole": MessageLookupByLibrary.simpleMessage(
            "Access denied: Incorrect role."),
        "accessDeniedMessage": MessageLookupByLibrary.simpleMessage(
            "Access denied: Incorrect role."),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "administrativeFee":
            MessageLookupByLibrary.simpleMessage("Administrative Fee"),
        "administrative_fee":
            MessageLookupByLibrary.simpleMessage("Administrative Fee"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "appTitle": MessageLookupByLibrary.simpleMessage("E-Library"),
        "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "art": MessageLookupByLibrary.simpleMessage("Art"),
        "assignment1": MessageLookupByLibrary.simpleMessage("Assignment 1"),
        "assignment_1": MessageLookupByLibrary.simpleMessage("Assignment 1"),
        "assignment_1_due":
            MessageLookupByLibrary.simpleMessage("Due today, 23.59"),
        "attendance_tracking":
            MessageLookupByLibrary.simpleMessage("Attendance Tracking"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelLabel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "certificates": MessageLookupByLibrary.simpleMessage("Certificates"),
        "class1": m0,
        "classes": MessageLookupByLibrary.simpleMessage("Classes"),
        "contact": MessageLookupByLibrary.simpleMessage("Contact"),
        "contact_school_id":
            MessageLookupByLibrary.simpleMessage("Contact / School ID"),
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
        "dateOfBirth": MessageLookupByLibrary.simpleMessage("Date of Birth"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloadLabel": MessageLookupByLibrary.simpleMessage("Download"),
        "downloadedTo": m1,
        "due_oct_16": MessageLookupByLibrary.simpleMessage("Due Oct 16, 23.59"),
        "due_oct_9": MessageLookupByLibrary.simpleMessage("Due Oct 9, 23.59"),
        "due_today": MessageLookupByLibrary.simpleMessage("Due today, 23.59"),
        "e_library": MessageLookupByLibrary.simpleMessage("E-Library"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "errorLabel": m2,
        "evenSemester": MessageLookupByLibrary.simpleMessage("Even"),
        "fatherName": MessageLookupByLibrary.simpleMessage("Father\'s Name"),
        "fee_payment_management":
            MessageLookupByLibrary.simpleMessage("Fee Payment Management"),
        "filterSubjects":
            MessageLookupByLibrary.simpleMessage("Filter Subjects"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
        "geography": MessageLookupByLibrary.simpleMessage("Geography"),
        "gpa": MessageLookupByLibrary.simpleMessage("GPA"),
        "grade": MessageLookupByLibrary.simpleMessage("Grade"),
        "gradeClass": MessageLookupByLibrary.simpleMessage("Grade/Class"),
        "grades": MessageLookupByLibrary.simpleMessage("Grades"),
        "grades_title": MessageLookupByLibrary.simpleMessage("Your Grades"),
        "hello": MessageLookupByLibrary.simpleMessage("Hello"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "inputGrades": m3,
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address."),
        "invalidEmailMessage": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address."),
        "invoice": MessageLookupByLibrary.simpleMessage("Invoice"),
        "invoiceTitle": MessageLookupByLibrary.simpleMessage("2023/2024"),
        "invoice_even": MessageLookupByLibrary.simpleMessage("Even"),
        "invoice_odd": MessageLookupByLibrary.simpleMessage("Odd"),
        "invoice_title": MessageLookupByLibrary.simpleMessage("Invoice"),
        "invoices": MessageLookupByLibrary.simpleMessage("Invoices"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "language_english": MessageLookupByLibrary.simpleMessage("English"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("Portuguese"),
        "list_of_subjects":
            MessageLookupByLibrary.simpleMessage("List of Subjects"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "loadingLabel":
            MessageLookupByLibrary.simpleMessage("Loading library..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
        "loginFailedMessage": m4,
        "loginPrompt": MessageLookupByLibrary.simpleMessage(
            "Login to your account to continue"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
            "Login to your account to continue"),
        "login_as_role": m5,
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "materials": MessageLookupByLibrary.simpleMessage("Materials"),
        "math": MessageLookupByLibrary.simpleMessage("Math"),
        "music": MessageLookupByLibrary.simpleMessage("Music"),
        "nameNotFound": MessageLookupByLibrary.simpleMessage("Name not found"),
        "nav_attendance": MessageLookupByLibrary.simpleMessage("Attendance"),
        "nav_dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "nav_home": MessageLookupByLibrary.simpleMessage("Home"),
        "nav_invoice": MessageLookupByLibrary.simpleMessage("Invoice"),
        "nav_notifications":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "nav_profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "noFilesAvailable":
            MessageLookupByLibrary.simpleMessage("No files available."),
        "noProfileData":
            MessageLookupByLibrary.simpleMessage("No profile data found."),
        "noScheduleAvailable":
            MessageLookupByLibrary.simpleMessage("No schedule available"),
        "noStudents": MessageLookupByLibrary.simpleMessage("No students found"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "oddSemester": MessageLookupByLibrary.simpleMessage("Odd"),
        "online_learning_04":
            MessageLookupByLibrary.simpleMessage("Online Learning #04"),
        "online_learning_04_due":
            MessageLookupByLibrary.simpleMessage("Due Oct 9, 23.59"),
        "online_learning_05":
            MessageLookupByLibrary.simpleMessage("Online Learning #05"),
        "online_learning_05_due":
            MessageLookupByLibrary.simpleMessage("Due Oct 16, 23.59"),
        "online_learning_4":
            MessageLookupByLibrary.simpleMessage("Online Learning #04"),
        "online_learning_5":
            MessageLookupByLibrary.simpleMessage("Online Learning #05"),
        "openSettings": MessageLookupByLibrary.simpleMessage("Open Settings"),
        "parent": MessageLookupByLibrary.simpleMessage("Parent"),
        "parentInfo":
            MessageLookupByLibrary.simpleMessage("Parent Information"),
        "parent_dashboard":
            MessageLookupByLibrary.simpleMessage("Parent Dashboard"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordRequirement": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters."),
        "placeOfBirth": MessageLookupByLibrary.simpleMessage("Place of Birth"),
        "pleaseEnterEmailAndPassword": MessageLookupByLibrary.simpleMessage(
            "Please enter your email and password"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "reports": MessageLookupByLibrary.simpleMessage("Reports"),
        "roleHeader": m6,
        "role_parent": MessageLookupByLibrary.simpleMessage("Parent"),
        "role_student": MessageLookupByLibrary.simpleMessage("Student"),
        "role_teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
        "scheduleTitle": MessageLookupByLibrary.simpleMessage("Schedule"),
        "schoolId": MessageLookupByLibrary.simpleMessage("School ID"),
        "science": MessageLookupByLibrary.simpleMessage("Science"),
        "select_role": MessageLookupByLibrary.simpleMessage("Select Role"),
        "select_your_role":
            MessageLookupByLibrary.simpleMessage("Select your role"),
        "semester_even": MessageLookupByLibrary.simpleMessage("Even"),
        "semester_odd": MessageLookupByLibrary.simpleMessage("Odd"),
        "shortPasswordMessage": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters."),
        "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signup_as_role": m7,
        "student": MessageLookupByLibrary.simpleMessage("Student"),
        "studentInfo":
            MessageLookupByLibrary.simpleMessage("Student Information"),
        "studentName": MessageLookupByLibrary.simpleMessage("Student Name"),
        "student_dashboard":
            MessageLookupByLibrary.simpleMessage("Student Dashboard"),
        "student_progress_monitoring":
            MessageLookupByLibrary.simpleMessage("Student Progress Monitoring"),
        "subject": MessageLookupByLibrary.simpleMessage("Subject"),
        "subject_arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "subject_art": MessageLookupByLibrary.simpleMessage("Art"),
        "subject_english": MessageLookupByLibrary.simpleMessage("English"),
        "subject_history": MessageLookupByLibrary.simpleMessage("History"),
        "subject_list_title":
            MessageLookupByLibrary.simpleMessage("List of Subjects"),
        "subject_math": MessageLookupByLibrary.simpleMessage("Mathematics"),
        "subject_physical_education":
            MessageLookupByLibrary.simpleMessage("Physical Education"),
        "subject_science": MessageLookupByLibrary.simpleMessage("Science"),
        "subjectsTitle": MessageLookupByLibrary.simpleMessage("Subjects"),
        "submitGrades": MessageLookupByLibrary.simpleMessage("Submit Grades"),
        "teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "teacherInfo":
            MessageLookupByLibrary.simpleMessage("Teacher Information"),
        "teacher_dashboard":
            MessageLookupByLibrary.simpleMessage("Teacher Dashboard"),
        "teacher_input_grades":
            MessageLookupByLibrary.simpleMessage("Teacher Input Grades Page"),
        "todo": MessageLookupByLibrary.simpleMessage("To-Do:"),
        "todo_assignment1_title":
            MessageLookupByLibrary.simpleMessage("Assignment 1"),
        "todo_due_date": m8,
        "todo_due_today":
            MessageLookupByLibrary.simpleMessage("Due today, 23:59"),
        "todo_online_learning4":
            MessageLookupByLibrary.simpleMessage("Online Learning #04"),
        "todo_online_learning5":
            MessageLookupByLibrary.simpleMessage("Online Learning #05"),
        "todo_title": MessageLookupByLibrary.simpleMessage("To-Do:"),
        "transcript": MessageLookupByLibrary.simpleMessage("Transcript"),
        "tuitionFee": MessageLookupByLibrary.simpleMessage("Tuition Fee"),
        "tuition_fee": MessageLookupByLibrary.simpleMessage("Tuition Fee"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "unknownRole": MessageLookupByLibrary.simpleMessage("Unknown role"),
        "unknownRoleMessage":
            MessageLookupByLibrary.simpleMessage("Unknown role"),
        "userInfo": MessageLookupByLibrary.simpleMessage("User Information"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome to the app!"),
        "whatsapp": MessageLookupByLibrary.simpleMessage("WhatsApp"),
        "year": MessageLookupByLibrary.simpleMessage("Year"),
        "your_grades": MessageLookupByLibrary.simpleMessage("Your Grades")
      };
}
