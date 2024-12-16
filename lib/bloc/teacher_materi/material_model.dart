class MaterialModel {
  final String id;
  final String title;
  final String description;
  final String fileLink;
  final DateTime createdAt;

  MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileLink,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fileLink': fileLink,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MaterialModel.fromMap(String id, Map<String, dynamic> map) {
    return MaterialModel(
      id: id,
      title: map['title'],
      description: map['description'],
      fileLink: map['fileLink'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
