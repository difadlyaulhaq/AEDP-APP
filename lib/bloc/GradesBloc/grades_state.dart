part of 'grades_bloc.dart';

abstract class GradesState {}

class GradesInitial extends GradesState {}

class GradesLoading extends GradesState {}

class GradesLoaded extends GradesState {
  final List<Map<String, dynamic>> grades;
  GradesLoaded({required this.grades});
}

class GradesUploading extends GradesState {}

class GradesUploaded extends GradesState {}

class GradesError extends GradesState {
  final String message;
  GradesError(this.message);
}
