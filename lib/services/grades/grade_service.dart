// services/grade_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_aedp/models/grade/grade_model.dart';

class GradeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<GradeDataResult> fetchSubjectsAndGrades({
    required String gradeClass,
    required String schoolId,
    required String examType,
  }) async {
    // Fetch subjects for this class
    final subjectDocs = await _firestore.collection('subjects').get();
    final filteredSubjects = subjectDocs.docs.where((doc) {
      String gradeStr = doc['grade'];
      List<String> grades = gradeStr.split(',');
      return grades.contains(gradeClass);
    }).toList();

    // Convert to Subject objects
    final subjects = filteredSubjects
        .map((doc) => Subject.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();

    // Create subject names map
    final subjectNames = <String, String>{};
    for (var subject in subjects) {
      subjectNames[subject.id] = subject.name;
    }

    // Fetch existing grades for this student and exam type
    final gradeDocs = await _firestore
        .collection('grades')
        .where('school_id', isEqualTo: schoolId)
        .where('exam_type', isEqualTo: examType)
        .get();

    final existingGradeIds = <String, String>{};
    final existingGrades = <String, String>{};

    for (var doc in gradeDocs.docs) {
      String subjectId = doc['subjectId'];
      if (subjectNames.containsKey(subjectId)) {
        existingGradeIds[subjectId] = doc.id;
        existingGrades[subjectId] = doc['grade'];
      }
    }

    return GradeDataResult(
      subjects: subjects,
      subjectNames: subjectNames,
      existingGradeIds: existingGradeIds,
      existingGrades: existingGrades,
    );
  }

  Future<void> submitGrades({
    required Map<String, TextEditingController> controllers,
    required Map<String, String> existingGradeIds,
    required Map<String, String> subjectNames,
    required GradeSubmissionData gradeData,
  }) async {
    for (var entry in controllers.entries) {
      String subjectId = entry.key;
      String gradeValue = entry.value.text;

      if (gradeValue.isNotEmpty) {
        if (existingGradeIds.containsKey(subjectId)) {
          // Update existing grade
          await _updateExistingGrade(
            existingGradeIds[subjectId]!,
            gradeValue,
            gradeData,
          );
        } else {
          // Add new grade
          await _addNewGrade(
            subjectId,
            subjectNames[subjectId]!,
            gradeValue,
            gradeData,
          );
        }
      }
    }
  }

  Future<void> _updateExistingGrade(
    String gradeId,
    String gradeValue,
    GradeSubmissionData gradeData,
  ) async {
    await _firestore
        .collection('grades')
        .doc(gradeId)
        .update(gradeData.toUpdateMap(gradeValue));
  }

  Future<void> _addNewGrade(
    String subjectId,
    String subjectName,
    String gradeValue,
    GradeSubmissionData gradeData,
  ) async {
    await _firestore
        .collection('grades')
        .add(gradeData.toMap(subjectId, subjectName, gradeValue));
  }
}