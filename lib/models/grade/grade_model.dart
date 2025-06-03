// models/grade_model.dart

class Subject {
  final String id;
  final String name;
  final String grade;

  Subject({
    required this.id,
    required this.name,
    required this.grade,
  });

  factory Subject.fromFirestore(String id, Map<String, dynamic> data) {
    return Subject(
      id: id,
      name: data['subject_name'] ?? '',
      grade: data['grade'] ?? '',
    );
  }
}

class GradeLevel {
  final bool isPrimary;
  final bool isSecondary;
  final int coefficient;
  final int periodCount;

  GradeLevel({
    required this.isPrimary,
    required this.isSecondary,
    required this.coefficient,
    required this.periodCount,
  });
}

class GradeDataResult {
  final List<Subject> subjects;
  final Map<String, String> subjectNames;
  final Map<String, String> existingGradeIds;
  final Map<String, String> existingGrades;

  GradeDataResult({
    required this.subjects,
    required this.subjectNames,
    required this.existingGradeIds,
    required this.existingGrades,
  });
}

class GradeSubmissionData {
  final String schoolId;
  final String studentName;
  final String gradeClass;
  final int coefficient;
  final String currentDate;
  final String examType;

  GradeSubmissionData({
    required this.schoolId,
    required this.studentName,
    required this.gradeClass,
    required this.coefficient,
    required this.currentDate,
    required this.examType,
  });

  Map<String, dynamic> toMap(String subjectId, String subjectName, String grade) {
    return {
      'school_id': schoolId,
      'student_name': studentName,
      'class': gradeClass,
      'subject': subjectName,
      'subjectId': subjectId,
      'grade': grade,
      'coefficient': coefficient,
      'date_added': currentDate,
      'exam_type': examType,
    };
  }

  Map<String, dynamic> toUpdateMap(String grade) {
    return {
      'grade': grade,
      'coefficient': coefficient,
      'date_updated': currentDate,
    };
  }
}