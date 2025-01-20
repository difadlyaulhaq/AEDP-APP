import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

part 'transcript_downloads_event.dart';
part 'transcript_downloads_state.dart';

class TranscriptDownloadsBloc extends Bloc<TranscriptDownloadsEvent, TranscriptDownloadsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TranscriptDownloadsBloc() : super(TranscriptDownloadsInitial()) {
    on<LoadTranscriptFiles>(_onLoadTranscriptFiles);
    on<DownloadTranscriptFile>(_onDownloadTranscriptFile);
  }

  Future<void> _onLoadTranscriptFiles(
    LoadTranscriptFiles event,
    Emitter<TranscriptDownloadsState> emit,
  ) async {
    emit(TranscriptDownloadsLoading());
    try {
      // Validasi dan ambil data user berdasarkan ID
      final userId = num.tryParse(event.userId);
      if (userId == null) {
        emit(TranscriptDownloadsError("Invalid user ID"));
        return;
      }

      // Query data user untuk mendapatkan role
      final userDoc = await _firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .get();

      if (userDoc.docs.isEmpty) {
        emit(TranscriptDownloadsError("User not found"));
        return;
      }

      final userData = userDoc.docs.first.data();
      final role = userData['role'] as String?;

      Query<Map<String, dynamic>> transcriptQuery = _firestore.collection('transcripts');

      if (role?.toLowerCase() == 'student') {
        // Untuk siswa, ambil transkrip berdasarkan student_id
        transcriptQuery = transcriptQuery.where('student_id', isEqualTo: userId.toString());
      } else if (role?.toLowerCase() == 'teacher') {
        // Untuk guru, ambil semua transkrip
        transcriptQuery = _firestore.collection('transcripts');
      } else if (role?.toLowerCase() == 'parent') {
        // Untuk orang tua, ambil transkrip anak-anaknya
        transcriptQuery = transcriptQuery.where('parent_id', isEqualTo: userId.toString());
      } else {
        emit(TranscriptDownloadsError("Invalid role"));
        return;
      }

      final snapshot = await transcriptQuery.get();

      if (snapshot.docs.isEmpty) {
        emit(TranscriptDownloadsError("No transcripts available"));
        return;
      }

      final transcripts = snapshot.docs.map((doc) {
        final data = doc.data();
        return TranscriptFile(
          name: data['student_name'] as String? ?? "Unknown Student",
          fatherName: data['father_name'] as String? ?? "Unknown Father",
          grades: data['grades'] as String? ?? "N/A",
          filePath: data['pdf_path'] as String? ?? "",
        );
      }).toList();

      emit(TranscriptDownloadsLoaded(files: transcripts));
    } catch (e) {
      emit(TranscriptDownloadsError("Error loading transcripts: $e"));
    }
  }

  Future<void> _onDownloadTranscriptFile(
    DownloadTranscriptFile event,
    Emitter<TranscriptDownloadsState> emit,
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

        emit(TranscriptDownloadSuccess(filePathToSave));
      } else {
        emit(TranscriptDownloadsError("Failed to download file: ${response.statusCode}"));
      }
    } catch (e) {
      emit(TranscriptDownloadsError("Error downloading file: $e"));
    }
  }
}

// Model class for TranscriptFile
class TranscriptFile {
  final String name;
  final String fatherName;
  final String grades;
  final String filePath;

  TranscriptFile({
    required this.name,
    required this.fatherName,
    required this.grades,
    required this.filePath,
  });
}
