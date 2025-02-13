import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aedp/bloc/library_download/library_download_event.dart';
import 'package:project_aedp/bloc/library_download/library_download_state.dart';

class LibraryDownloadBloc extends Bloc<LibraryDownloadEvent, LibraryDownloadState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LibraryDownloadBloc() : super(LibraryDownloadInitial()) {
    on<LoadLibraryFiles>(_onLoadLibraryFiles);
  }

  Future<void> _onLoadLibraryFiles(
    LoadLibraryFiles event,
    Emitter<LibraryDownloadState> emit,
  ) async {
    emit(LibraryDownloadLoading());
    try {
      // Parse and validate userId
      final userId = num.tryParse(event.userId);
      if (userId == null) {
        emit(LibraryDownloadError("Invalid user ID"));
        return;
      }

      // First get user data and check role
      final userDoc = await _firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .get();

      if (userDoc.docs.isEmpty) {
        emit(LibraryDownloadError("User not found"));
        return;
      }

      final userData = userDoc.docs.first.data();
      final role = userData['role'] as String?;

      Query<Map<String, dynamic>> libraryQuery = _firestore.collection('library');

      if (role?.toLowerCase() == 'student') {
        // For students, get their grade and filter books
        final studentDoc = await _firestore
            .collection('students')
            .where('school_id', isEqualTo: userId.toString())
            .limit(1)
            .get();

        if (studentDoc.docs.isEmpty) {
          emit(LibraryDownloadError("Student data not found"));
          return;
        }

        final studentData = studentDoc.docs.first.data();
        final studentGrade = studentData['grade_class'];

        // Fetch library books for student's grade
        libraryQuery = libraryQuery.where('grade', isEqualTo: studentGrade);
      } else if (role?.toLowerCase() == 'teacher') {
        // For teachers, fetch all library books
        libraryQuery = _firestore.collection('library');
      } else if (role?.toLowerCase() == 'parent') {
        // For parents, fetch all library books
        libraryQuery = _firestore.collection('library');
      } else {
        emit(LibraryDownloadError("Invalid role"));
        return;
      }

      final snapshot = await libraryQuery.get();

      if (snapshot.docs.isEmpty) {
        emit(LibraryDownloadError("No books available"));
        return;
      }

      final files = snapshot.docs.map((doc) {
        final data = doc.data();
        return LibraryFile(
          name: data['name'] as String? ?? "Unknown Name",
          filePath: data['file_path'] as String? ?? "",
        );
      }).toList();

      emit(LibraryDownloadLoaded(files: files));
    } catch (e) {
      emit(LibraryDownloadError("Error loading library files: $e"));
    }
  }
}