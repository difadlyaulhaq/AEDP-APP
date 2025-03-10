part of 'grades_bloc.dart';

abstract class GradesEvent {}

class LoadGrades extends GradesEvent {
  final String role;
  final String? schoolId;
  final String? studentName;
  final String? classes;
  final String? examType;
  LoadGrades({required this.role, this.schoolId, this.studentName, this.classes, this.examType});
}

class UploadGrades extends GradesEvent {
  final String schoolId;
  final String studentName;
  final String gradeClass;
  final String examType;

  UploadGrades({
    required this.examType,
    required this.schoolId,
    required this.studentName,
    required this.gradeClass,
  });
}
