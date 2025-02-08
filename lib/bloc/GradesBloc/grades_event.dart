part of 'grades_bloc.dart';

abstract class GradesEvent {}

class LoadGrades extends GradesEvent {
  final String role;
  final String? schoolId;
  final String? studentName;
  final String? classes;

  LoadGrades({required this.role, this.schoolId, this.studentName, this.classes});
}

class UploadGrades extends GradesEvent {
  final String schoolId;
  final String studentName;
  final String gradeClass;

  UploadGrades({
    required this.schoolId,
    required this.studentName,
    required this.gradeClass,
  });
}
