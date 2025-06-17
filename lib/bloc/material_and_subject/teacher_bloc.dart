import 'dart:developer';
// import 'dart:io';
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
          List<String> teacherClasses = event.teacherClasses.split(',').map((e) => e.trim()).toList();
          query = query.where('grade', whereIn: teacherClasses);
        } else {
          // PERBAIKAN: Filter langsung di query untuk student
          query = query.where('grade', isEqualTo: event.studentGradeClass);
        }

        final snapshot = await query.get();
        List<MaterialModel> materials = [];

        for (var doc in snapshot.docs) {
          MaterialModel material = MaterialModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);

          // PERBAIKAN: Validasi tambahan lebih ketat
          if (!event.isTeacher) {
            // Student hanya boleh melihat materi dengan grade yang EXACT match
            if (material.grade.trim() != event.studentGradeClass.trim()) {
              continue;
            }
          }

          if (event.isTeacher) {
            List<String> teacherClasses = event.teacherClasses.split(',').map((e) => e.trim()).toList();
            if (!teacherClasses.contains(material.grade.trim())) {
              continue;
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
          final data = doc.data();
          final subjectName = data['subject_name'] ?? 'Unknown';
          final grades = data['grade'] ?? '';
          
          // PERBAIKAN: Parsing grades dengan lebih hati-hati
          List<String> subjectGrades = [];
          if (grades is String && grades.isNotEmpty) {
            subjectGrades = grades.split(',').map((grade) => grade.trim()).toList();
          } else if (grades is List) {
            subjectGrades = grades.map((grade) => grade.toString().trim()).toList();
          }

          bool isEligible = false;
          if (event.isTeacher) {
            final teacherClasses = event.teacherClasses.split(',').map((e) => e.trim()).toList();
            isEligible = subjectGrades.any((grade) => teacherClasses.contains(grade));
          } else {
            // PERBAIKAN: Student hanya melihat subject yang mendukung grade mereka
            isEligible = subjectGrades.contains(event.studentGradeClass.trim());
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

          // PERBAIKAN: Kembalikan grade yang spesifik untuk student
          String specificGrade = event.isTeacher ? grades : event.studentGradeClass;

          return SubjectModel(
            id: doc.id,
            grade: specificGrade, // Gunakan grade spesifik
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
        final grades = data?['grade'];

        if (grades is List) {
          return grades.map((grade) => grade.toString().trim()).toList();
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