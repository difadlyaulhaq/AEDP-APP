import 'dart:io';
import 'package:equatable/equatable.dart';
import 'material_model.dart';

abstract class MaterialEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMaterials extends MaterialEvent {
  final String subjectId;

  FetchMaterials({required this.subjectId});

  @override
  List<Object?> get props => [subjectId];
}

class AddMaterial extends MaterialEvent {
  final MaterialModel material;
  final File file;

  AddMaterial({required this.material, required this.file});

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
