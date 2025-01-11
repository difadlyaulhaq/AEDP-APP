import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  final String id;
  final String title;
  final String description;
  final String fileLink;
  final DateTime createdAt;
  final String subjectId; // Use subjectId

  MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileLink,
    required this.createdAt,
    required this.subjectId,
  });

  factory MaterialModel.fromMap(String id, Map<String, dynamic> data) {
    return MaterialModel(
      id: id,
      title: data['title'],
      description: data['description'],
      fileLink: data['fileLink'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      subjectId: data['subjectId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'fileLink': fileLink,
      'createdAt': createdAt,
      'subjectId': subjectId,
    };
  }
}