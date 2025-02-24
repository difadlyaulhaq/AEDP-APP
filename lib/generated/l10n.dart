// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mother's Name`
  String get mother_name {
    return Intl.message(
      'Mother\'s Name',
      name: 'mother_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter grade (0-100)`
  String get enterGrade {
    return Intl.message(
      'Enter grade (0-100)',
      name: 'enterGrade',
      desc: '',
      args: [],
    );
  }

  /// `Grades uploaded successfully`
  String get gradesUploaded {
    return Intl.message(
      'Grades uploaded successfully',
      name: 'gradesUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Student Details`
  String get studentDetails {
    return Intl.message(
      'Student Details',
      name: 'studentDetails',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get error {
    return Intl.message(
      'An error occurred',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Input Grades Page`
  String get teacher_input_grades {
    return Intl.message(
      'Teacher Input Grades Page',
      name: 'teacher_input_grades',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `No students found`
  String get noStudents {
    return Intl.message(
      'No students found',
      name: 'noStudents',
      desc: '',
      args: [],
    );
  }

  /// `School ID`
  String get schoolId {
    return Intl.message(
      'School ID',
      name: 'schoolId',
      desc: '',
      args: [],
    );
  }

  /// `Class: {grade}`
  String class1(Object grade) {
    return Intl.message(
      'Class: $grade',
      name: 'class1',
      desc: '',
      args: [grade],
    );
  }

  /// `Input Grades for {name}`
  String inputGrades(Object name) {
    return Intl.message(
      'Input Grades for $name',
      name: 'inputGrades',
      desc: '',
      args: [name],
    );
  }

  /// `Submit Grades`
  String get submitGrades {
    return Intl.message(
      'Submit Grades',
      name: 'submitGrades',
      desc: '',
      args: [],
    );
  }

  /// `Contact / School ID`
  String get contact_school_id {
    return Intl.message(
      'Contact / School ID',
      name: 'contact_school_id',
      desc: '',
      args: [],
    );
  }

  /// `Transcript`
  String get transcript {
    return Intl.message(
      'Transcript',
      name: 'transcript',
      desc: '',
      args: [],
    );
  }

  /// `E-Library`
  String get appTitle {
    return Intl.message(
      'E-Library',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Dashboard`
  String get teacher_dashboard {
    return Intl.message(
      'Teacher Dashboard',
      name: 'teacher_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `No files available.`
  String get noFilesAvailable {
    return Intl.message(
      'No files available.',
      name: 'noFilesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded to {path}`
  String downloadedTo(Object path) {
    return Intl.message(
      'Downloaded to $path',
      name: 'downloadedTo',
      desc: '',
      args: [path],
    );
  }

  /// `Loading library...`
  String get loadingLabel {
    return Intl.message(
      'Loading library...',
      name: 'loadingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get downloadLabel {
    return Intl.message(
      'Download',
      name: 'downloadLabel',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get openSettings {
    return Intl.message(
      'Open Settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelLabel {
    return Intl.message(
      'Cancel',
      name: 'cancelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Your Grades`
  String get grades_title {
    return Intl.message(
      'Your Grades',
      name: 'grades_title',
      desc: '',
      args: [],
    );
  }

  /// `List of Subjects`
  String get subject_list_title {
    return Intl.message(
      'List of Subjects',
      name: 'subject_list_title',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Information`
  String get teacherInfo {
    return Intl.message(
      'Teacher Information',
      name: 'teacherInfo',
      desc: '',
      args: [],
    );
  }

  /// `Student Information`
  String get studentInfo {
    return Intl.message(
      'Student Information',
      name: 'studentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Parent Information`
  String get parentInfo {
    return Intl.message(
      'Parent Information',
      name: 'parentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get whatsapp {
    return Intl.message(
      'WhatsApp',
      name: 'whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Classes`
  String get classes {
    return Intl.message(
      'Classes',
      name: 'classes',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Place of Birth`
  String get placeOfBirth {
    return Intl.message(
      'Place of Birth',
      name: 'placeOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Grade/Class`
  String get gradeClass {
    return Intl.message(
      'Grade/Class',
      name: 'gradeClass',
      desc: '',
      args: [],
    );
  }

  /// `Father's Name`
  String get fatherName {
    return Intl.message(
      'Father\'s Name',
      name: 'fatherName',
      desc: '',
      args: [],
    );
  }

  /// `Student Name`
  String get studentName {
    return Intl.message(
      'Student Name',
      name: 'studentName',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get nav_dashboard {
    return Intl.message(
      'Dashboard',
      name: 'nav_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get nav_notifications {
    return Intl.message(
      'Notifications',
      name: 'nav_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Attendance Tracking`
  String get attendance_tracking {
    return Intl.message(
      'Attendance Tracking',
      name: 'attendance_tracking',
      desc: '',
      args: [],
    );
  }

  /// `Student Progress Monitoring`
  String get student_progress_monitoring {
    return Intl.message(
      'Student Progress Monitoring',
      name: 'student_progress_monitoring',
      desc: '',
      args: [],
    );
  }

  /// `Fee Payment Management`
  String get fee_payment_management {
    return Intl.message(
      'Fee Payment Management',
      name: 'fee_payment_management',
      desc: '',
      args: [],
    );
  }

  /// `Certificates`
  String get certificates {
    return Intl.message(
      'Certificates',
      name: 'certificates',
      desc: '',
      args: [],
    );
  }

  /// `Parent Dashboard`
  String get parent_dashboard {
    return Intl.message(
      'Parent Dashboard',
      name: 'parent_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Student Dashboard`
  String get student_dashboard {
    return Intl.message(
      'Student Dashboard',
      name: 'student_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Invoices`
  String get invoices {
    return Intl.message(
      'Invoices',
      name: 'invoices',
      desc: '',
      args: [],
    );
  }

  /// `Mathematics`
  String get subject_math {
    return Intl.message(
      'Mathematics',
      name: 'subject_math',
      desc: '',
      args: [],
    );
  }

  /// `Science`
  String get subject_science {
    return Intl.message(
      'Science',
      name: 'subject_science',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get subject_history {
    return Intl.message(
      'History',
      name: 'subject_history',
      desc: '',
      args: [],
    );
  }

  /// `Physical Education`
  String get subject_physical_education {
    return Intl.message(
      'Physical Education',
      name: 'subject_physical_education',
      desc: '',
      args: [],
    );
  }

  /// `Art`
  String get subject_art {
    return Intl.message(
      'Art',
      name: 'subject_art',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get subject_english {
    return Intl.message(
      'English',
      name: 'subject_english',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get subject_arabic {
    return Intl.message(
      'Arabic',
      name: 'subject_arabic',
      desc: '',
      args: [],
    );
  }

  /// `Your Grades`
  String get your_grades {
    return Intl.message(
      'Your Grades',
      name: 'your_grades',
      desc: '',
      args: [],
    );
  }

  /// `List of Subjects`
  String get list_of_subjects {
    return Intl.message(
      'List of Subjects',
      name: 'list_of_subjects',
      desc: '',
      args: [],
    );
  }

  /// `GPA`
  String get gpa {
    return Intl.message(
      'GPA',
      name: 'gpa',
      desc: '',
      args: [],
    );
  }

  /// `Odd`
  String get semester_odd {
    return Intl.message(
      'Odd',
      name: 'semester_odd',
      desc: '',
      args: [],
    );
  }

  /// `Even`
  String get semester_even {
    return Intl.message(
      'Even',
      name: 'semester_even',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message(
      'Subject',
      name: 'subject',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get grade {
    return Intl.message(
      'Grade',
      name: 'grade',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice_title {
    return Intl.message(
      'Invoice',
      name: 'invoice_title',
      desc: '',
      args: [],
    );
  }

  /// `Even`
  String get invoice_even {
    return Intl.message(
      'Even',
      name: 'invoice_even',
      desc: '',
      args: [],
    );
  }

  /// `Odd`
  String get invoice_odd {
    return Intl.message(
      'Odd',
      name: 'invoice_odd',
      desc: '',
      args: [],
    );
  }

  /// `Tuition Fee`
  String get tuition_fee {
    return Intl.message(
      'Tuition Fee',
      name: 'tuition_fee',
      desc: '',
      args: [],
    );
  }

  /// `Administrative Fee`
  String get administrative_fee {
    return Intl.message(
      'Administrative Fee',
      name: 'administrative_fee',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `2023/2024`
  String get invoiceTitle {
    return Intl.message(
      '2023/2024',
      name: 'invoiceTitle',
      desc: 'The academic year shown at the top of the invoice',
      args: [],
    );
  }

  /// `Even`
  String get evenSemester {
    return Intl.message(
      'Even',
      name: 'evenSemester',
      desc: 'Label for even semester section',
      args: [],
    );
  }

  /// `Odd`
  String get oddSemester {
    return Intl.message(
      'Odd',
      name: 'oddSemester',
      desc: 'Label for odd semester section',
      args: [],
    );
  }

  /// `Tuition Fee`
  String get tuitionFee {
    return Intl.message(
      'Tuition Fee',
      name: 'tuitionFee',
      desc: 'Label for tuition fee item',
      args: [],
    );
  }

  /// `Administrative Fee`
  String get administrativeFee {
    return Intl.message(
      'Administrative Fee',
      name: 'administrativeFee',
      desc: 'Label for administrative fee item',
      args: [],
    );
  }

  /// `Invoice`
  String get nav_invoice {
    return Intl.message(
      'Invoice',
      name: 'nav_invoice',
      desc: '',
      args: [],
    );
  }

  /// `To-Do:`
  String get todo_title {
    return Intl.message(
      'To-Do:',
      name: 'todo_title',
      desc: '',
      args: [],
    );
  }

  /// `Assignment 1`
  String get assignment_1 {
    return Intl.message(
      'Assignment 1',
      name: 'assignment_1',
      desc: '',
      args: [],
    );
  }

  /// `Due today, 23.59`
  String get assignment_1_due {
    return Intl.message(
      'Due today, 23.59',
      name: 'assignment_1_due',
      desc: '',
      args: [],
    );
  }

  /// `Online Learning #04`
  String get online_learning_04 {
    return Intl.message(
      'Online Learning #04',
      name: 'online_learning_04',
      desc: '',
      args: [],
    );
  }

  /// `Due Oct 9, 23.59`
  String get online_learning_04_due {
    return Intl.message(
      'Due Oct 9, 23.59',
      name: 'online_learning_04_due',
      desc: '',
      args: [],
    );
  }

  /// `Online Learning #05`
  String get online_learning_05 {
    return Intl.message(
      'Online Learning #05',
      name: 'online_learning_05',
      desc: '',
      args: [],
    );
  }

  /// `Due Oct 16, 23.59`
  String get online_learning_05_due {
    return Intl.message(
      'Due Oct 16, 23.59',
      name: 'online_learning_05_due',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message(
      'Invoice',
      name: 'invoice',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `To-Do:`
  String get todo {
    return Intl.message(
      'To-Do:',
      name: 'todo',
      desc: '',
      args: [],
    );
  }

  /// `Assignment 1`
  String get assignment1 {
    return Intl.message(
      'Assignment 1',
      name: 'assignment1',
      desc: '',
      args: [],
    );
  }

  /// `Due today, 23.59`
  String get due_today {
    return Intl.message(
      'Due today, 23.59',
      name: 'due_today',
      desc: '',
      args: [],
    );
  }

  /// `Online Learning #04`
  String get online_learning_4 {
    return Intl.message(
      'Online Learning #04',
      name: 'online_learning_4',
      desc: '',
      args: [],
    );
  }

  /// `Due Oct 9, 23.59`
  String get due_oct_9 {
    return Intl.message(
      'Due Oct 9, 23.59',
      name: 'due_oct_9',
      desc: '',
      args: [],
    );
  }

  /// `Online Learning #05`
  String get online_learning_5 {
    return Intl.message(
      'Online Learning #05',
      name: 'online_learning_5',
      desc: '',
      args: [],
    );
  }

  /// `Due Oct 16, 23.59`
  String get due_oct_16 {
    return Intl.message(
      'Due Oct 16, 23.59',
      name: 'due_oct_16',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message(
      'Schedule',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// `Materials`
  String get materials {
    return Intl.message(
      'Materials',
      name: 'materials',
      desc: '',
      args: [],
    );
  }

  /// `Grades`
  String get grades {
    return Intl.message(
      'Grades',
      name: 'grades',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `E-Library`
  String get e_library {
    return Intl.message(
      'E-Library',
      name: 'e_library',
      desc: '',
      args: [],
    );
  }

  /// `Subjects`
  String get subjectsTitle {
    return Intl.message(
      'Subjects',
      name: 'subjectsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Filter Subjects`
  String get filterSubjects {
    return Intl.message(
      'Filter Subjects',
      name: 'filterSubjects',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Math`
  String get math {
    return Intl.message(
      'Math',
      name: 'math',
      desc: '',
      args: [],
    );
  }

  /// `Science`
  String get science {
    return Intl.message(
      'Science',
      name: 'science',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Geography`
  String get geography {
    return Intl.message(
      'Geography',
      name: 'geography',
      desc: '',
      args: [],
    );
  }

  /// `Art`
  String get art {
    return Intl.message(
      'Art',
      name: 'art',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get scheduleTitle {
    return Intl.message(
      'Schedule',
      name: 'scheduleTitle',
      desc: '',
      args: [],
    );
  }

  /// `No schedule available`
  String get noScheduleAvailable {
    return Intl.message(
      'No schedule available',
      name: 'noScheduleAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message(
      'Profile',
      name: 'profileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Name not found`
  String get nameNotFound {
    return Intl.message(
      'Name not found',
      name: 'nameNotFound',
      desc: '',
      args: [],
    );
  }

  /// `No profile data found.`
  String get noProfileData {
    return Intl.message(
      'No profile data found.',
      name: 'noProfileData',
      desc: '',
      args: [],
    );
  }

  /// `User Information`
  String get userInfo {
    return Intl.message(
      'User Information',
      name: 'userInfo',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Error: {errorMessage}`
  String errorLabel(Object errorMessage) {
    return Intl.message(
      'Error: $errorMessage',
      name: 'errorLabel',
      desc: '',
      args: [errorMessage],
    );
  }

  /// `Home`
  String get nav_home {
    return Intl.message(
      'Home',
      name: 'nav_home',
      desc: '',
      args: [],
    );
  }

  /// `Attendance`
  String get nav_attendance {
    return Intl.message(
      'Attendance',
      name: 'nav_attendance',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get nav_profile {
    return Intl.message(
      'Profile',
      name: 'nav_profile',
      desc: '',
      args: [],
    );
  }

  /// `To-Do:`
  String get dashboard_todo_header {
    return Intl.message(
      'To-Do:',
      name: 'dashboard_todo_header',
      desc: '',
      args: [],
    );
  }

  /// `Assignment 1`
  String get todo_assignment1_title {
    return Intl.message(
      'Assignment 1',
      name: 'todo_assignment1_title',
      desc: '',
      args: [],
    );
  }

  /// `Due today, 23:59`
  String get todo_due_today {
    return Intl.message(
      'Due today, 23:59',
      name: 'todo_due_today',
      desc: '',
      args: [],
    );
  }

  /// `Online Learning #04`
  String get todo_online_learning4 {
    return Intl.message(
      'Online Learning #04',
      name: 'todo_online_learning4',
      desc: '',
      args: [],
    );
  }

  /// `Online Learning #05`
  String get todo_online_learning5 {
    return Intl.message(
      'Online Learning #05',
      name: 'todo_online_learning5',
      desc: '',
      args: [],
    );
  }

  /// `Due {date}, 23:59`
  String todo_due_date(String date) {
    return Intl.message(
      'Due $date, 23:59',
      name: 'todo_due_date',
      desc: '',
      args: [date],
    );
  }

  /// `Schedule`
  String get dashboard_schedule {
    return Intl.message(
      'Schedule',
      name: 'dashboard_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Materials`
  String get dashboard_materials {
    return Intl.message(
      'Materials',
      name: 'dashboard_materials',
      desc: '',
      args: [],
    );
  }

  /// `Grades`
  String get dashboard_grades {
    return Intl.message(
      'Grades',
      name: 'dashboard_grades',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get dashboard_reports {
    return Intl.message(
      'Reports',
      name: 'dashboard_reports',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get dashboard_notifications {
    return Intl.message(
      'Notifications',
      name: 'dashboard_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Attendance`
  String get dashboard_attendance {
    return Intl.message(
      'Attendance',
      name: 'dashboard_attendance',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email and password`
  String get pleaseEnterEmailAndPassword {
    return Intl.message(
      'Please enter your email and password',
      name: 'pleaseEnterEmailAndPassword',
      desc: '',
      args: [],
    );
  }

  /// `Select your role`
  String get select_your_role {
    return Intl.message(
      'Select your role',
      name: 'select_your_role',
      desc: '',
      args: [],
    );
  }

  /// `Login as {role}`
  String login_as_role(Object role) {
    return Intl.message(
      'Login as $role',
      name: 'login_as_role',
      desc: '',
      args: [role],
    );
  }

  /// `Signup as {role}`
  String signup_as_role(Object role) {
    return Intl.message(
      'Signup as $role',
      name: 'signup_as_role',
      desc: '',
      args: [role],
    );
  }

  /// `English`
  String get language_english {
    return Intl.message(
      'English',
      name: 'language_english',
      desc: '',
      args: [],
    );
  }

  /// `Portuguese`
  String get language_portuguese {
    return Intl.message(
      'Portuguese',
      name: 'language_portuguese',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get language_arabic {
    return Intl.message(
      'Arabic',
      name: 'language_arabic',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get role_student {
    return Intl.message(
      'Student',
      name: 'role_student',
      desc: '',
      args: [],
    );
  }

  /// `Parent`
  String get role_parent {
    return Intl.message(
      'Parent',
      name: 'role_parent',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get role_teacher {
    return Intl.message(
      'Teacher',
      name: 'role_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Select Role`
  String get select_role {
    return Intl.message(
      'Select Role',
      name: 'select_role',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get student {
    return Intl.message(
      'Student',
      name: 'student',
      desc: '',
      args: [],
    );
  }

  /// `Parent`
  String get parent {
    return Intl.message(
      'Parent',
      name: 'parent',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get teacher {
    return Intl.message(
      'Teacher',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the app!`
  String get welcome {
    return Intl.message(
      'Welcome to the app!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message(
      'Login',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmailMessage {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters.`
  String get shortPasswordMessage {
    return Intl.message(
      'Password must be at least 6 characters.',
      name: 'shortPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `{role} Login`
  String roleHeader(Object role) {
    return Intl.message(
      '$role Login',
      name: 'roleHeader',
      desc: '',
      args: [role],
    );
  }

  /// `Login to your account to continue`
  String get loginSubtitle {
    return Intl.message(
      'Login to your account to continue',
      name: 'loginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Access denied: Incorrect role.`
  String get accessDeniedMessage {
    return Intl.message(
      'Access denied: Incorrect role.',
      name: 'accessDeniedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unknown role`
  String get unknownRoleMessage {
    return Intl.message(
      'Unknown role',
      name: 'unknownRoleMessage',
      desc: '',
      args: [],
    );
  }

  /// `Login failed: {errorMessage}`
  String loginFailedMessage(Object errorMessage) {
    return Intl.message(
      'Login failed: $errorMessage',
      name: 'loginFailedMessage',
      desc: '',
      args: [errorMessage],
    );
  }

  /// `Access denied: Incorrect role.`
  String get accessDeniedIncorrectRole {
    return Intl.message(
      'Access denied: Incorrect role.',
      name: 'accessDeniedIncorrectRole',
      desc: '',
      args: [],
    );
  }

  /// `Unknown role`
  String get unknownRole {
    return Intl.message(
      'Unknown role',
      name: 'unknownRole',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account to continue`
  String get loginPrompt {
    return Intl.message(
      'Login to your account to continue',
      name: 'loginPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters.`
  String get passwordRequirement {
    return Intl.message(
      'Password must be at least 6 characters.',
      name: 'passwordRequirement',
      desc: '',
      args: [],
    );
  }

  /// `Authenticating login request`
  String get AuthLoginRequested {
    return Intl.message(
      'Authenticating login request',
      name: 'AuthLoginRequested',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
