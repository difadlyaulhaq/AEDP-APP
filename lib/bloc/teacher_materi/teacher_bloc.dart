import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'material_event.dart';
import 'material_state.dart';
import 'material_model.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  MaterialBloc() : super(MaterialLoading()) {
    on<FetchMaterials>((event, emit) async {
      try {
        emit(MaterialLoading());

        final snapshot = await firestore
            .collection('materials')
            .where('subjectId', isEqualTo: event.subjectId) // Fetch by subjectId
            .get();

        final materials = snapshot.docs
            .map((doc) => MaterialModel.fromMap(doc.id, doc.data()))
            .toList();

        emit(MaterialLoaded(materials));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });

    on<AddMaterial>((event, emit) async {
      try {
        await firestore
            .collection('materials')
            .doc(event.material.id)
            .set(event.material.toMap());

        // Automatically fetch updated materials after adding a new one
        add(FetchMaterials(subjectId: event.material.subjectId));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });
  }
}