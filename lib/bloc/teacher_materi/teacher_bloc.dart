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

        // Filter based on multiple subjects by checking if the material's subject is in the provided list
        final snapshot = await firestore
            .collection('materials')
            .where('subject', whereIn: event.subjects)  // Use `whereIn` to filter based on the list of subjects
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
        add(FetchMaterials(subjects: [event.material.subject])); // Filter based on subject
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });
  }
}
