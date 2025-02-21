import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:translator/translator.dart';
import 'material_event.dart';
import 'material_state.dart';
import 'material_model.dart';
import 'subject_model.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  MaterialBloc() : super(MaterialLoading()) {
    // Fetch materials filtered by subjectId and grade
   on<FetchMaterials>((event, emit) async {
  try {
    emit(MaterialLoading());
    final translator = GoogleTranslator();

    Query query = firestore.collection('materials').where('subjectId', isEqualTo: event.subjectId);

    if (event.isTeacher) {
      List<String> teacherClasses = event.teacherClasses.split(',');
      query = query.where('grade', whereIn: teacherClasses);
    } else {
      query = query.where('grade', isEqualTo: event.studentGradeClass);
    }

    final snapshot = await query.get();
    List<MaterialModel> materials = [];

    for (var doc in snapshot.docs) {
      MaterialModel material = MaterialModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);

      // **Tambahkan Validasi**
      if (!event.isTeacher && material.grade != event.studentGradeClass) {
        continue; // Jika siswa, hanya boleh melihat materi dengan grade yang cocok
      }

      if (event.isTeacher) {
        List<String> teacherClasses = event.teacherClasses.split(',');
        if (!teacherClasses.contains(material.grade)) {
          continue; // Jika guru, hanya boleh melihat materi sesuai kelas yang diajar
        }
      }

      // Terjemahkan title materi jika bahasa yang dipilih bukan default
      String translatedTitle = material.title;
      if (event.selectedLanguage == 'ar') {
        translatedTitle = (await translator.translate(material.title, to: 'ar')).text;
      } else if (event.selectedLanguage == 'en') {
        translatedTitle = (await translator.translate(material.title, to: 'en')).text;
      } else if (event.selectedLanguage == 'pt') {
        translatedTitle = (await translator.translate(material.title, to: 'pt')).text;
      }

      // Simpan hasil terjemahan ke dalam objek
      materials.add(material.copyWith(title: translatedTitle));
    }

    emit(MaterialLoaded(materials));
  } catch (e) {
    emit(MaterialError(e.toString()));
  }
});


    // Upload material with PDF
    on<AddMaterial>((event, emit) async {
      try {
        emit(MaterialUploading());

        // Upload PDF file ke Firebase Storage
        String fileName = basename(event.file.path);
        Reference storageRef = storage.ref().child('materials/$fileName');
        UploadTask uploadTask = storageRef.putFile(event.file);

        TaskSnapshot snapshot = await uploadTask;
        String fileURL = await snapshot.ref.getDownloadURL();

        // Simpan materi ke Firestore dengan grade
        MaterialModel material = event.material.copyWith(
          fileLink: fileURL,
          grade: event.grade, // Simpan grade
        );

        await firestore.collection('materials').doc(material.id).set(material.toMap());

        // Refresh data setelah upload selesai
        add(FetchMaterials(
          subjectId: material.subjectId,
          grade: event.grade,
          selectedLanguage: 'en', // Default ke English, bisa diubah
          isTeacher: false, 
          teacherClasses: '',
          studentGradeClass: event.grade
        ));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });

    // Fetch subjects with translation & grade filtering
    on<FetchSubjects>((event, emit) async {
      try {
        emit(MaterialLoading());
        QuerySnapshot snapshot = await firestore.collection('subjects').get();
        final translator = GoogleTranslator();
        final List<SubjectModel> subjects = [];

        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          String subjectName = data['subject_name'] ?? 'Unknown';
          String grades = data['grade'] ?? '';

          // Pecah daftar grade menjadi List<String>
          List<String> subjectGrades = grades.split(',');

          // Filter berdasarkan role
          bool isEligible = false;
          if (event.isTeacher) {
            List<String> teacherClasses = event.teacherClasses.split(',');
            isEligible = subjectGrades.any((grade) => teacherClasses.contains(grade));
          } else {
            isEligible = subjectGrades.contains(event.studentGradeClass);
          }

          if (isEligible) {
            // Terjemahkan nama subject jika diperlukan
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
              grade: grades,
              subjectName: translatedSubject,
            ));
          }
        }
        emit(SubjectsLoaded(subjects));
      } catch (e) {
        emit(MaterialError(e.toString()));
      }
    });
  }
}
