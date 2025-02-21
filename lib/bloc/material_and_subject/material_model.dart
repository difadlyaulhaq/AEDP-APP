class MaterialModel {
  final String id;
  final String title;
  final String description;
  final String fileLink;
  final String grade;
  final String subjectId;

  MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileLink,
    required this.grade,
    required this.subjectId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'fileLink': fileLink,
      'grade': grade, // Simpan grade ke Firestore
      'subjectId': subjectId,
    };
  }

  factory MaterialModel.fromMap(String id, Map<String, dynamic> data) {
    return MaterialModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      fileLink: data['fileLink'] ?? '',
      grade: data['grade'] ?? '', // Ambil grade dari Firestore
      subjectId: data['subjectId'] ?? '',
    );
  }

  MaterialModel copyWith({
    String? id,
    String? title,
    String? description,
    String? fileLink,
    String? grade,
    String? subjectId,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      fileLink: fileLink ?? this.fileLink,
      grade: grade ?? this.grade,
      subjectId: subjectId ?? this.subjectId,
    );
  }
}
