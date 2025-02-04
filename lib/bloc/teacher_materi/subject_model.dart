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
  if (!data.containsKey('grade')) {
    print("⚠️ Warning: Subject ${id} is missing 'grade' field!");
  }

  return SubjectModel(
    id: id,
    subjectName: data['subject_name'] ?? 'Unknown Subject',
    grade: data['grade']?.toString().trim() ?? 'Unknown Grade',  // Handle null values
  );
}



  Map<String, dynamic> toMap() {
    return {
      'subject_name': subjectName,
      'grade': grade,
    };
  }
}
