import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_aedp/bloc/library_download/library_download_event.dart';
import 'package:project_aedp/bloc/library_download/library_download_state.dart';

class LibraryDownloadBloc extends Bloc<LibraryDownloadEvent, LibraryDownloadState> {
  LibraryDownloadBloc() : super(LibraryDownloadInitial()) {
    on<DownloadFile>(_onDownloadFile);
    on<LoadLibraryFiles>(_onLoadLibraryFiles);
  }

  Future<void> _onDownloadFile(
    DownloadFile event,
    Emitter<LibraryDownloadState> emit,
  ) async {
    emit(LibraryDownloadLoading());

    try {
      // Check storage permission
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          emit(LibraryDownloadError("Storage permission is required to download files"));
          return;
        }
      }

      // Fetch file data from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('library')
          .doc(event.filePath)
          .get();

      if (!snapshot.exists) {
        emit(LibraryDownloadError("File not found in Firestore"));
        return;
      }

      final filePath = snapshot.data()?['file_path'] as String?;
      if (filePath == null || filePath.isEmpty || !filePath.endsWith('.pdf')) {
        emit(LibraryDownloadError("Invalid file path in Firestore"));
        return;
      }

      // Combine base URL with relative path
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/"; // Replace with your actual base URL
      final downloadUrl = Uri.parse(baseUrl).resolve(filePath).toString();

      // Download the file
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        // Get the downloads directory for Android or documents directory for iOS
        final directory = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();

        // Create directory if it doesn't exist
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Save the file
        final fileName = filePath.split('/').last;
        final filePathToSave = '${directory.path}/$fileName';
        final file = File(filePathToSave);
        await file.writeAsBytes(response.bodyBytes);

        // Emit success with the file path
        emit(LibraryDownloadLoaded(filePath: filePathToSave));
      } else {
        emit(LibraryDownloadError(
          "Failed to download file: ${response.statusCode}",
        ));
      }
    } catch (e) {
      emit(LibraryDownloadError("Error downloading file: $e"));
    }
  }

  Future<void> _onLoadLibraryFiles(
    LoadLibraryFiles event,
    Emitter<LibraryDownloadState> emit,
  ) async {
    // Simulate loading files from Firestore or API
    await Future.delayed(const Duration(seconds: 2));

    final files = [
      LibraryFile(name: 'Week 12 Notes', filePath: 'uploads/week 12.pdf'),
    ];

    // Emit the loaded files state
    emit(LibraryDownloadLoaded(files: files));
  }
}
