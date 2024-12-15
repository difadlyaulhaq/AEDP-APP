abstract class TeacherState {}

class TeacherInitial extends TeacherState {}

class MaterialsLoading extends TeacherState {}

class MaterialsLoaded extends TeacherState {
  final List<Map<String, dynamic>> materials;

  MaterialsLoaded(this.materials);
}

class MaterialsError extends TeacherState {
  final String error;

  MaterialsError(this.error);
}
