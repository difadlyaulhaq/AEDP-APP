import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aedp/bloc/teacher_materi/material_event.dart';
import 'package:project_aedp/bloc/teacher_materi/material_state.dart';
import 'material_model.dart';


class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  MaterialBloc() : super(MaterialLoading()) {
    on<FetchMaterials>((event, emit) async {
      try {
        emit(MaterialLoading());
        final snapshot = await firestore.collection('materials').get();
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
        add(FetchMaterials()); // Refresh the list
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });
  }
}
