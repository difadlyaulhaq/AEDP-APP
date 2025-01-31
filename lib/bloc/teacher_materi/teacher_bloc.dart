import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'material_event.dart';
import 'material_state.dart';
import 'material_model.dart';
import 'subject_model.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  MaterialBloc() : super(MaterialLoading()) {
    // Fetch materials filtered by subjectId
    on<FetchMaterials>((event, emit) async {
      try {
        emit(MaterialLoading());

        final snapshot = await firestore
            .collection('materials')
            .where('subjectId', isEqualTo: event.subjectId)
            .get();

        final materials = snapshot.docs
            .map((doc) => MaterialModel.fromMap(doc.id, doc.data()))
            .toList();

        emit(MaterialLoaded(materials));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });

    // Fetch subjects based on filtering rules
    on<FetchSubjects>((event, emit) async {
      try {
        emit(MaterialLoading());

        Query query = firestore.collection('subjects');

        // Check if the user is a teacher or student
        if (event.isTeacher) {
          // Filter by classes (split by ",")
          List<String> classes = event.teacherClasses.split(',');
          query = query.where('grade', whereIn: classes);
        } else {
          // Filter by grade_class for students
          query = query.where('grade', isEqualTo: event.studentGradeClass);
        }

        final snapshot = await query.get();

        final subjects = snapshot.docs
            .map((doc) => SubjectModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();

        emit(SubjectsLoaded(subjects));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });

    // Add new material
    on<AddMaterial>((event, emit) async {
      try {
        await firestore
            .collection('materials')
            .doc(event.material.id)
            .set(event.material.toMap());

        add(FetchMaterials(subjectId: event.material.subjectId));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });
  }
}
