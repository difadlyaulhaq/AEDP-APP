import 'package:equatable/equatable.dart';
import 'package:project_aedp/bloc/material_and_subject/material_model.dart';
import 'package:project_aedp/bloc/material_and_subject/subject_model.dart';

abstract class MaterialState extends Equatable {
  const MaterialState();

  @override
  List<Object> get props => [];
}

class MaterialLoading extends MaterialState {}

class MaterialLoaded extends MaterialState {
  final List<MaterialModel> materials;

  const MaterialLoaded(this.materials);

  @override
  List<Object> get props => [materials];
}

class MaterialError extends MaterialState {
  final String errorMessage;

  const MaterialError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
class SubjectsLoaded extends MaterialState {
  final List<SubjectModel> subjects;
  const SubjectsLoaded(this.subjects);
}
