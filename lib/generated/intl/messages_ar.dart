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

  static String m0(grade) => "الصف: ${grade}";

  static String m1(path) => "تم التنزيل إلى ${path}";

  static String m2(errorMessage) => "خطأ: ${errorMessage}";

  static String m3(name) => "إدخال الدرجات لـ ${name}";

  static String m4(errorMessage) => "فشل تسجيل الدخول: ${errorMessage}";

  static String m5(role) => "تسجيل الدخول كـ ${role}";

  static String m6(role) => "تسجيل الدخول كـ ${role}";

  static String m7(id) => "رقم المدرسة: ${id}";

  static String m8(role) => "إنشاء حساب كـ ${role}";

  static String m9(date) => "يستحق ${date}، 23:59";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthLoginRequested":
            MessageLookupByLibrary.simpleMessage("طلب تسجيل الدخول جار التحقق"),
        "accessDeniedIncorrectRole": MessageLookupByLibrary.simpleMessage(
            "تم رفض الوصول: الدور غير صحيح."),
        "accessDeniedMessage":
            MessageLookupByLibrary.simpleMessage("تم الرفض: دور غير صحيح."),
        "address": MessageLookupByLibrary.simpleMessage("العنوان"),
        "administrativeFee":
            MessageLookupByLibrary.simpleMessage("الرسوم الإدارية"),
        "administrative_fee":
            MessageLookupByLibrary.simpleMessage("رسوم إدارية"),
        "all": MessageLookupByLibrary.simpleMessage("الكل"),
        "appTitle": MessageLookupByLibrary.simpleMessage("المكتبة الإلكترونية"),
        "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "art": MessageLookupByLibrary.simpleMessage("الفن"),
        "assignment1": MessageLookupByLibrary.simpleMessage("المهمة 1"),
        "assignment_1": MessageLookupByLibrary.simpleMessage("التكليف 1"),
        "assignment_1_due":
            MessageLookupByLibrary.simpleMessage("الاستحقاق اليوم، 23:59"),
        "attendance_tracking":
            MessageLookupByLibrary.simpleMessage("تتبع الحضور"),
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "cancelLabel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "certificates": MessageLookupByLibrary.simpleMessage("الشهادات"),
        "class1": m0,
        "classes": MessageLookupByLibrary.simpleMessage("الصف:"),
        "classesAssigned":
            MessageLookupByLibrary.simpleMessage("الصفوف المسندة:"),
        "contact": MessageLookupByLibrary.simpleMessage("التواصل"),
        "contact_school_id":
            MessageLookupByLibrary.simpleMessage("الاتصال / رقم تعريف المدرسة"),
        "dashboard_attendance": MessageLookupByLibrary.simpleMessage("الحضور"),
        "dashboard_grades": MessageLookupByLibrary.simpleMessage("الدرجات"),
        "dashboard_materials": MessageLookupByLibrary.simpleMessage("المواد"),
        "dashboard_notifications":
            MessageLookupByLibrary.simpleMessage("الإشعارات"),
        "dashboard_reports": MessageLookupByLibrary.simpleMessage("التقارير"),
        "dashboard_schedule": MessageLookupByLibrary.simpleMessage("الجدول"),
        "dashboard_todo_header":
            MessageLookupByLibrary.simpleMessage("المهام:"),
        "dateOfBirth": MessageLookupByLibrary.simpleMessage("تاريخ الميلاد"),
        "download": MessageLookupByLibrary.simpleMessage("تحميل"),
        "downloadLabel": MessageLookupByLibrary.simpleMessage("تنزيل"),
        "downloadedTo": m1,
        "due_oct_16":
            MessageLookupByLibrary.simpleMessage("مستحق 16 أكتوبر، 23.59"),
        "due_oct_9":
            MessageLookupByLibrary.simpleMessage("مستحق 9 أكتوبر، 23.59"),
        "due_today": MessageLookupByLibrary.simpleMessage("مستحق اليوم، 23.59"),
        "e_library":
            MessageLookupByLibrary.simpleMessage("المكتبة الإلكترونية"),
        "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
        "enterGrade":
            MessageLookupByLibrary.simpleMessage("أدخل الدرجة (0-20)"),
        "enterGradeValue":
            MessageLookupByLibrary.simpleMessage("أدخل الدرجة (0-20)"),
        "enterGrades": MessageLookupByLibrary.simpleMessage("إدخال الدرجات"),
        "error": MessageLookupByLibrary.simpleMessage("حدث خطأ"),
        "errorLabel": m2,
        "evenSemester": MessageLookupByLibrary.simpleMessage("الفصل الزوجي"),
        "fatherName": MessageLookupByLibrary.simpleMessage("اسم الأب"),
        "fee_payment_management":
            MessageLookupByLibrary.simpleMessage("إدارة دفع الرسوم"),
        "filterSubjects": MessageLookupByLibrary.simpleMessage("تصفية المواد"),
        "firstPeriod": MessageLookupByLibrary.simpleMessage("الفترة الأولى"),
        "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
        "geography": MessageLookupByLibrary.simpleMessage("الجغرافيا"),
        "gpa": MessageLookupByLibrary.simpleMessage("المعدل التراكمي"),
        "grade": MessageLookupByLibrary.simpleMessage("الدرجة"),
        "gradeClass": MessageLookupByLibrary.simpleMessage("الصف"),
        "gradeValidation":
            MessageLookupByLibrary.simpleMessage("يجب أن تكون الدرجة بين 0-20"),
        "grades": MessageLookupByLibrary.simpleMessage("الدرجات"),
        "gradesUploaded":
            MessageLookupByLibrary.simpleMessage("تم رفع الدرجات"),
        "hello": MessageLookupByLibrary.simpleMessage("مرحبًا"),
        "history": MessageLookupByLibrary.simpleMessage("التاريخ"),
        "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "inputGrades": m3,
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال عنوان بريد إلكتروني صالح."),
        "invalidEmailMessage": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال عنوان بريد إلكتروني صالح."),
        "invoice": MessageLookupByLibrary.simpleMessage("الفاتورة"),
        "invoiceTitle": MessageLookupByLibrary.simpleMessage("٢٠٢٣/٢٠٢٤"),
        "invoice_even": MessageLookupByLibrary.simpleMessage("زوجي"),
        "invoice_odd": MessageLookupByLibrary.simpleMessage("فردي"),
        "invoice_title": MessageLookupByLibrary.simpleMessage("الفاتورة"),
        "invoices": MessageLookupByLibrary.simpleMessage("الفواتير"),
        "language": MessageLookupByLibrary.simpleMessage("اللغة"),
        "language_arabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "language_english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
        "language_portuguese":
            MessageLookupByLibrary.simpleMessage("البرتغالية"),
        "list_of_subjects":
            MessageLookupByLibrary.simpleMessage("قائمة المواد"),
        "loading": MessageLookupByLibrary.simpleMessage("جار التحميل..."),
        "loadingLabel":
            MessageLookupByLibrary.simpleMessage("جارٍ تحميل المكتبة..."),
        "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "loginButton": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("فشل تسجيل الدخول"),
        "loginFailedMessage": m4,
        "loginPrompt": MessageLookupByLibrary.simpleMessage(
            "تسجيل الدخول إلى حسابك للمتابعة"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
            "قم بتسجيل الدخول إلى حسابك للمتابعة"),
        "login_as_role": m5,
        "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
        "materials": MessageLookupByLibrary.simpleMessage("المواد"),
        "math": MessageLookupByLibrary.simpleMessage("الرياضيات"),
        "maxGrade20":
            MessageLookupByLibrary.simpleMessage("الحد الأقصى للدرجة هو 20"),
        "maxGradeValue":
            MessageLookupByLibrary.simpleMessage("الحد الأقصى للدرجة"),
        "mother_name": MessageLookupByLibrary.simpleMessage("اسم الأم"),
        "music": MessageLookupByLibrary.simpleMessage("الموسيقى"),
        "nameNotFound": MessageLookupByLibrary.simpleMessage("الاسم غير موجود"),
        "nav_attendance": MessageLookupByLibrary.simpleMessage("الحضور"),
        "nav_dashboard": MessageLookupByLibrary.simpleMessage("لوحة القيادة"),
        "nav_home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "nav_invoice": MessageLookupByLibrary.simpleMessage("الفاتورة"),
        "nav_notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
        "nav_profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
        "noFilesAvailable":
            MessageLookupByLibrary.simpleMessage("لا توجد ملفات متاحة."),
        "noProfileData": MessageLookupByLibrary.simpleMessage(
            "لا توجد بيانات للملف الشخصي."),
        "noScheduleAvailable":
            MessageLookupByLibrary.simpleMessage("لا يوجد جدول متاح"),
        "noStudents":
            MessageLookupByLibrary.simpleMessage("لم يتم العثور على طلاب"),
        "noSubjects":
            MessageLookupByLibrary.simpleMessage("لا توجد مواد متاحة"),
        "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
        "oddSemester": MessageLookupByLibrary.simpleMessage("الفصل الفردي"),
        "online_learning_04":
            MessageLookupByLibrary.simpleMessage("التعلم عبر الإنترنت #04"),
        "online_learning_04_due":
            MessageLookupByLibrary.simpleMessage("الاستحقاق 9 أكتوبر، 23:59"),
        "online_learning_05":
            MessageLookupByLibrary.simpleMessage("التعلم عبر الإنترنت #05"),
        "online_learning_05_due":
            MessageLookupByLibrary.simpleMessage("الاستحقاق 16 أكتوبر، 23:59"),
        "online_learning_4":
            MessageLookupByLibrary.simpleMessage("التعلم عبر الإنترنت #04"),
        "online_learning_5":
            MessageLookupByLibrary.simpleMessage("التعلم عبر الإنترنت #05"),
        "openSettings": MessageLookupByLibrary.simpleMessage("افتح الإعدادات"),
        "parent": MessageLookupByLibrary.simpleMessage("والد/والدة"),
        "parentInfo": MessageLookupByLibrary.simpleMessage("معلومات ولي الأمر"),
        "parent_dashboard":
            MessageLookupByLibrary.simpleMessage("لوحة تحكم الوالدين"),
        "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordRequirement": MessageLookupByLibrary.simpleMessage(
            "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل."),
        "placeOfBirth": MessageLookupByLibrary.simpleMessage("مكان الميلاد"),
        "pleaseEnterEmailAndPassword": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال البريد الإلكتروني وكلمة المرور"),
        "previouslyGraded":
            MessageLookupByLibrary.simpleMessage("تم تقييمها مسبقًا"),
        "profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
        "reports": MessageLookupByLibrary.simpleMessage("التقارير"),
        "roleHeader": m6,
        "role_parent": MessageLookupByLibrary.simpleMessage("والد"),
        "role_student": MessageLookupByLibrary.simpleMessage("طالب"),
        "role_teacher": MessageLookupByLibrary.simpleMessage("معلم"),
        "schedule": MessageLookupByLibrary.simpleMessage("الجدول"),
        "scheduleTitle": MessageLookupByLibrary.simpleMessage("الجدول"),
        "schoolId": m7,
        "science": MessageLookupByLibrary.simpleMessage("العلوم"),
        "secondPeriod": MessageLookupByLibrary.simpleMessage("الفترة الثانية"),
        "select_role": MessageLookupByLibrary.simpleMessage("اختيار الدور"),
        "select_your_role": MessageLookupByLibrary.simpleMessage("اختر دورك"),
        "semester_even": MessageLookupByLibrary.simpleMessage("زوجي"),
        "semester_odd": MessageLookupByLibrary.simpleMessage("فردي"),
        "shortPasswordMessage": MessageLookupByLibrary.simpleMessage(
            "يجب أن تكون كلمة المرور مكونة من 6 أحرف على الأقل."),
        "signup": MessageLookupByLibrary.simpleMessage("التسجيل"),
        "signup_as_role": m8,
        "student": MessageLookupByLibrary.simpleMessage("طالب"),
        "studentDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الطالب"),
        "studentInfo": MessageLookupByLibrary.simpleMessage("معلومات الطالب"),
        "studentName": MessageLookupByLibrary.simpleMessage("اسم الطالب"),
        "student_dashboard":
            MessageLookupByLibrary.simpleMessage("لوحة الطالب"),
        "student_progress_monitoring":
            MessageLookupByLibrary.simpleMessage("مراقبة تقدم الطالب"),
        "subject": MessageLookupByLibrary.simpleMessage("الموضوع"),
        "subject_arabic": MessageLookupByLibrary.simpleMessage("عربي"),
        "subject_art": MessageLookupByLibrary.simpleMessage("فن"),
        "subject_english": MessageLookupByLibrary.simpleMessage("إنجليزي"),
        "subject_history": MessageLookupByLibrary.simpleMessage("تاريخ"),
        "subject_math": MessageLookupByLibrary.simpleMessage("رياضيات"),
        "subject_physical_education":
            MessageLookupByLibrary.simpleMessage("التربية البدنية"),
        "subject_science": MessageLookupByLibrary.simpleMessage("علوم"),
        "subjectsTitle": MessageLookupByLibrary.simpleMessage("المواد"),
        "submitGrades": MessageLookupByLibrary.simpleMessage("تقديم الدرجات"),
        "teacher": MessageLookupByLibrary.simpleMessage("معلم"),
        "teacherInfo": MessageLookupByLibrary.simpleMessage("معلومات المعلم"),
        "teacherSchedule": MessageLookupByLibrary.simpleMessage("جدول المعلم"),
        "teacher_dashboard":
            MessageLookupByLibrary.simpleMessage("لوحة تحكم المعلم"),
        "teacher_input_grades":
            MessageLookupByLibrary.simpleMessage("صفحة إدخال الدرجات للمعلم"),
        "thirdPeriod": MessageLookupByLibrary.simpleMessage("الفترة الثالثة"),
        "todo": MessageLookupByLibrary.simpleMessage("المهام:"),
        "todo_assignment1_title":
            MessageLookupByLibrary.simpleMessage("الواجب 1"),
        "todo_due_date": m9,
        "todo_due_today":
            MessageLookupByLibrary.simpleMessage("يستحق اليوم، 23:59"),
        "todo_online_learning4":
            MessageLookupByLibrary.simpleMessage("التعلم عن بعد #04"),
        "todo_online_learning5":
            MessageLookupByLibrary.simpleMessage("التعلم عن بعد #05"),
        "todo_title": MessageLookupByLibrary.simpleMessage("المهام:"),
        "transcript": MessageLookupByLibrary.simpleMessage("النص"),
        "tuitionFee": MessageLookupByLibrary.simpleMessage("الرسوم الدراسية"),
        "tuition_fee": MessageLookupByLibrary.simpleMessage("رسوم الدراسة"),
        "unknown": MessageLookupByLibrary.simpleMessage("غير معروف"),
        "unknownRole": MessageLookupByLibrary.simpleMessage("دور غير معروف"),
        "unknownRoleMessage":
            MessageLookupByLibrary.simpleMessage("دور غير معروف"),
        "uploading": MessageLookupByLibrary.simpleMessage("جاري الرفع..."),
        "userInfo": MessageLookupByLibrary.simpleMessage("معلومات المستخدم"),
        "viewGrades": MessageLookupByLibrary.simpleMessage("عرض الدرجات"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("مرحبًا بك في التطبيق!"),
        "whatsapp": MessageLookupByLibrary.simpleMessage("واتساب"),
        "year": MessageLookupByLibrary.simpleMessage("السنة"),
        "your_grades": MessageLookupByLibrary.simpleMessage("درجاتك")
      };
}
