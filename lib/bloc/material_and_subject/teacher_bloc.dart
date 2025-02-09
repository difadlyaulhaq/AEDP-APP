import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'material_event.dart';
import 'material_state.dart';
import 'material_model.dart';
import 'subject_model.dart';
import 'package:translator/translator.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

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

    // Upload material with PDF
    on<AddMaterial>((event, emit) async {
      try {
        emit(MaterialUploading());

        // Upload PDF file to Firebase Storage
        String fileName = basename(event.file.path);
        Reference storageRef = storage.ref().child('materials/$fileName');
        UploadTask uploadTask = storageRef.putFile(event.file);

        TaskSnapshot snapshot = await uploadTask;
        String fileURL = await snapshot.ref.getDownloadURL();

        // Save material data to Firestore
        MaterialModel material = event.material.copyWith(fileLink: fileURL);
        await firestore.collection('materials').doc(material.id).set(material.toMap());

        add(FetchMaterials(subjectId: material.subjectId));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });

    // Fetch subjects with translation
    on<FetchSubjects>((event, emit) async {
      try {
        emit(MaterialLoading());
        Query query = firestore.collection('subjects');

        if (event.isTeacher) {
          List<String> classes = event.teacherClasses.split(',');
          query = query.where('grade', whereIn: classes);
        } else {
          query = query.where('grade', isEqualTo: event.studentGradeClass);
        }

        final snapshot = await query.get();
        final translator = GoogleTranslator();
        final List<SubjectModel> subjects = [];

        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          String subjectName = data['subject_name'] ?? 'Unknown';

          String translatedSubject = subjectName;
          if (event.selectedLanguage == 'ar') {
            translatedSubject = (await translator.translate(subjectName, to: 'ar')).text;
          } else if (event.selectedLanguage == 'en') {
            translatedSubject = (await translator.translate(subjectName, to: 'en')).text;
          } else if (event.selectedLanguage == 'pt') {
            translatedSubject = (await translator.translate(subjectName, to: 'pt')).text;
          }

          subjects.add(SubjectModel(
            id: doc.id,
            grade: data['grade'] ?? '',
            subjectName: translatedSubject,
          ));
        }
        emit(SubjectsLoaded(subjects));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });
  }
}






