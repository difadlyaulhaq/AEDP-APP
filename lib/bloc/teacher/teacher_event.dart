abstract class TeacherEvent {}

class LoadMaterials extends TeacherEvent {}

class AddMaterial extends TeacherEvent {
  final String title;
  final String description;
  final String filePath;

  AddMaterial(this.title, this.description, this.filePath);
}

class DeleteMaterial extends TeacherEvent {
  final String id;

  DeleteMaterial(this.id);
}
