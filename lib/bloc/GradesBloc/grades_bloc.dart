import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'grades_event.dart';
part 'grades_state.dart';

class GradesBloc extends Bloc<GradesEvent, GradesState> {
  final FirebaseFirestore _firestore;

  GradesBloc(this._firestore) : super(GradesInitial()) {
    on<LoadGrades>(_onLoadGrades);
    on<UploadGrades>(_onUploadGrades);
  }

  Future<void> _onLoadGrades(
    LoadGrades event,
    Emitter<GradesState> emit,
  ) async {
    emit(GradesLoading());
    try {
      QuerySnapshot gradeDocs;

      if (event.role == 'teacher') {
        // Filter kelas yang diajar oleh guru
        List<String> classes = event.classes?.split(',') ?? [];
        gradeDocs = await _firestore
            .collection('grades')
            .where('class', whereIn: classes)
            .get();
      } else if (event.role == 'student') {
        // Filter berdasarkan school_id siswa
        gradeDocs = await _firestore
            .collection('grades')
            .where('school_id', isEqualTo: event.schoolId)
            .get();
      } else if (event.role == 'parent') {
        // Filter berdasarkan nama siswa yang dicari oleh orang tua
        gradeDocs = await _firestore
            .collection('grades')
            .where('student_name', isEqualTo: event.studentName)
            .get();
      } else {
        throw Exception('Invalid role');
      }

      List<Map<String, dynamic>> grades =
          gradeDocs.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      emit(GradesLoaded(grades: grades));
    } catch (e) {
      emit(GradesError(e.toString()));
    }
  }

  Future<void> _onUploadGrades(
    UploadGrades event,
    Emitter<GradesState> emit,
  ) async {
    emit(GradesUploading());
    try {
      // Ambil daftar mata pelajaran sesuai kelas siswa
      QuerySnapshot subjectDocs = await _firestore
          .collection('subjects')
          .where('grade', isEqualTo: event.gradeClass)
          .get();

      List<Map<String, dynamic>> subjects = subjectDocs.docs
          .map((doc) => {'subject_name': doc['subject_name'], 'score': 0})
          .toList();

      // Data nilai siswa yang akan diunggah
      Map<String, dynamic> gradeData = {
        'school_id': event.schoolId,
        'student_name': event.studentName,
        'class': event.gradeClass,
        'subjects': subjects,
      };

      await _firestore.collection('grades').add(gradeData);
      emit(GradesUploaded());
    } catch (e) {
      emit(GradesError(e.toString()));
    }
  }
}
