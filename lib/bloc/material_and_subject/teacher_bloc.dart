import 'dart:developer';
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
   

   on<FetchSubjects>((event, emit) async {
  try {
    emit(MaterialLoading());
    final snapshot = await firestore.collection('subjects').get();
    final translator = GoogleTranslator();

    final List<SubjectModel> subjects = [];

    final List<Future<SubjectModel?>> futures = snapshot.docs.map((doc) async {
      final data = doc.data() as Map<String, dynamic>;
      final subjectName = data['subject_name'] ?? 'Unknown';
      final grades = data['grade'] ?? '';
      final subjectGrades = grades.split(',');

      bool isEligible = false;
      if (event.isTeacher) {
        final teacherClasses = event.teacherClasses.split(',');
        isEligible = subjectGrades.any((grade) => teacherClasses.contains(grade));
      } else {
        isEligible = subjectGrades.contains(event.studentGradeClass);
      }

      if (!isEligible) return null;

      String translatedSubject = subjectName;
      if (event.selectedLanguage != 'id') {
        try {
          translatedSubject = (await translator.translate(subjectName, to: event.selectedLanguage)).text;
        } catch (_) {
          // Fallback in case of translation error
          translatedSubject = subjectName;
        }
      }

      return SubjectModel(
        id: doc.id,
        grade: grades,
        subjectName: translatedSubject,
      );
    }).toList();

    final results = await Future.wait(futures);
    subjects.addAll(results.whereType<SubjectModel>());

    emit(SubjectsLoaded(subjects));
  } catch (e) {
    emit(MaterialError(e.toString()));
  }
});

  }
     Future<List<String>> fetchGradesForSubject(String subjectId) async {
  try {
    final snapshot = await firestore
        .collection('subjects')
        .doc(subjectId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      final grades = data?['grade']; // <- perhatikan singular/plural disesuaikan

      if (grades is List) {
        return grades.map((grade) => grade.toString()).toList();
      } else if (grades is String) {
        return grades.split(',').map((grade) => grade.trim()).toList();
      }
    }
    return [];
  } catch (e) {
    log("Error fetching grades: $e");
    return [];
  }
}

}