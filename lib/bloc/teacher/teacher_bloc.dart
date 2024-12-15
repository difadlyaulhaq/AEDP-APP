import 'package:flutter_bloc/flutter_bloc.dart';
import 'teacher_event.dart';
import 'teacher_state.dart';
import 'package:project_aedp/bloc/teacher/teacher_repository.dart';
class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final TeacherRepository repository;

  TeacherBloc(this.repository) : super(TeacherInitial()) {
    on<LoadMaterials>((event, emit) async {
      emit(MaterialsLoading());
      try {
        final materialsStream = repository.getMaterials();
        await emit.forEach(materialsStream, onData: (data) => MaterialsLoaded(data));
      } catch (e) {
        emit(MaterialsError(e.toString()));
      }
    });

    on<AddMaterial>((event, emit) async {
      try {
        final fileUrl = await repository.uploadFile(event.filePath, event.title);
        await repository.addMaterial(event.title, event.description, fileUrl);
      } catch (e) {
        emit(MaterialsError(e.toString()));
      }
    });

    on<DeleteMaterial>((event, emit) async {
      try {
        await repository.deleteMaterial(event.id);
      } catch (e) {
        emit(MaterialsError(e.toString()));
      }
    });
  }
}
