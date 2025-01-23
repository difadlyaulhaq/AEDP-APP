import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:project_aedp/bloc/library_download/library_download_event.dart';
import 'package:project_aedp/bloc/library_download/library_download_state.dart';

// Bloc Implementation
class LibraryDownloadBloc extends Bloc<LibraryDownloadEvent, LibraryDownloadState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LibraryDownloadBloc() : super(LibraryDownloadInitial()) {
    on<LoadLibraryFiles>(_onLoadLibraryFiles);
    on<DownloadFile>(_onDownloadFile);
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
      }else if (role?.toLowerCase() == 'parent') {
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

  Future<void> _onDownloadFile(
    DownloadFile event,
    Emitter<LibraryDownloadState> emit,
  ) async {
    try {
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(event.filePath).toString();

      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        final directory = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final fileName = event.filePath.split('/').last;
        final filePathToSave = '${directory.path}/$fileName';
        final file = File(filePathToSave);
        await file.writeAsBytes(response.bodyBytes);

        emit(LibraryDownloadSuccess(filePathToSave));
      } else {
        emit(LibraryDownloadError("Failed to download file: ${response.statusCode}"));
      }
    } catch (e) {              
      emit(LibraryDownloadError("Error downloading file: $e"));
    }
  }
}
