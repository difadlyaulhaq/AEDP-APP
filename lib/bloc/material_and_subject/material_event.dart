import 'dart:io';
import 'package:equatable/equatable.dart';
import 'material_model.dart';

abstract class MaterialEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMaterials extends MaterialEvent {
  final String subjectId;
  final String grade;
  final String selectedLanguage; 
  final bool isTeacher;
  final String teacherClasses;
  final String studentGradeClass;

  FetchMaterials(
      {required this.subjectId,
      required this.grade,
      required this.selectedLanguage,
      required this.isTeacher,
      required this.teacherClasses,
      required this.studentGradeClass

      }); 
  @override
  List<Object?> get props => [subjectId];
}

class AddMaterial extends MaterialEvent {
  final MaterialModel material;
  final File file;
  final grade;

  AddMaterial({required this.material, required this.file, required this.grade});

  @override
  List<Object?> get props => [material, file];
}

class FetchSubjects extends MaterialEvent {
  final bool isTeacher;
  final String teacherClasses;
  final String studentGradeClass;
  final String selectedLanguage; // Tambahkan parameter bahasa

  FetchSubjects({
    required this.isTeacher,
    required this.teacherClasses,
    required this.studentGradeClass,
    required this.selectedLanguage, // Tambahkan ke konstruktor
  });
}
