class SubjectModel {
  final String id;
  final String subjectName;
  final String grade;

  SubjectModel({
    required this.id,
    required this.subjectName,
    required this.grade,
  });

  factory SubjectModel.fromMap(String id, Map<String, dynamic> data) {
    return SubjectModel(
      id: id,
      subjectName: data['subject_name'],
      grade: data['grade'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject_name': subjectName,
      'grade': grade,
    };
  }
}
