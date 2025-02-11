class MaterialModel {
  final String id;
  final String title;
  final String description;
  final String fileLink;
  final String grade;
  final String subjectId;
  // final DateTime createdAt;

  MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileLink,
    required this.grade,
    required this.subjectId,
    // required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'fileLink': fileLink,
      'grade': grade,
      'subjectId': subjectId,
      // 'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MaterialModel.fromMap(String id, Map<String, dynamic> data) {
    return MaterialModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      fileLink: data['fileLink'] ?? '',
      grade: data['grade'] ?? '',
      subjectId: data['subjectId'] ?? '',
      // createdAt: DateTime.parse(data['createdAt']),
    );
  }

  MaterialModel copyWith({
    String? id,
    String? title,
    String? description,
    String? fileLink,
    String? grade,
    String? subjectId,
    // DateTime? createdAt,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      fileLink: fileLink ?? this.fileLink,
      grade: grade ?? this.grade,
      subjectId: subjectId ?? this.subjectId,
      // createdAt: createdAt ?? this.createdAt,
    );
  }
}
