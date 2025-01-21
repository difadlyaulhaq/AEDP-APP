import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_aedp/bloc/transcript_downloads/transcript_item.dart';

part 'transcript_downloads_event.dart';
part 'transcript_downloads_state.dart';

class TranscriptDownloadsBloc extends Bloc<TranscriptDownloadsEvent, TranscriptDownloadsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TranscriptDownloadsBloc() : super(TranscriptDownloadsInitial()) {
    on<LoadTranscripts>(_onLoadTranscripts);
    on<DownloadTranscript>(_onDownloadTranscript);
    on<ReloadTranscripts>(_onReloadTranscripts);
  }

  Future<void> _onReloadTranscripts(
    ReloadTranscripts event,
    Emitter<TranscriptDownloadsState> emit,
  ) async {
    emit(TranscriptsLoading());

    try {
      final transcriptsSnapshot = await _firestore
          .collection('transcripts')
          .where('father_name', isEqualTo: event.fatherName)
          .get();

      final transcripts = transcriptsSnapshot.docs.map((doc) {
        final data = doc.data();
        return TranscriptItem(
          name: data['student_name'] ?? 'Unknown Student',
          fatherName: data['father_name'] ?? 'Unknown',
          grades: data['grades'] ?? 'N/A',
          filePath: data['pdf_path'] ?? '',
        );
      }).toList();

      emit(TranscriptsLoaded(transcripts: transcripts));
    } catch (e) {
      emit(TranscriptDownloadsError('Error reloading transcripts: $e'));
    }
  }
  
  Future<void> _onLoadTranscripts(
    LoadTranscripts event,
    Emitter<TranscriptDownloadsState> emit,
  ) async {
    emit(TranscriptsLoading());

    try {
      final transcriptsSnapshot = await _firestore
          .collection('transcripts')
          .where('father_name', isEqualTo: event.fatherName)
          .get();

      final transcripts = transcriptsSnapshot.docs.map((doc) {
        final data = doc.data();
        return TranscriptItem(
          name: data['student_name'] ?? 'Unknown Student',
          fatherName: data['father_name'] ?? 'Unknown',
          grades: data['grades'] ?? 'N/A',
          filePath: data['pdf_path'] ?? '',
        );
      }).toList();

      emit(TranscriptsLoaded(transcripts: transcripts));
    } catch (e) {
      emit(TranscriptDownloadsError('Error loading transcripts: $e'));
    }
  }

  Future<void> _onDownloadTranscript(
    DownloadTranscript event,
    Emitter<TranscriptDownloadsState> emit,
  ) async {
    emit(TranscriptsDownloading());

    try {
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          emit(TranscriptDownloadsError("Storage permission is required to download files"));
          return;
        }
      }

      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(event.pdfPath).toString();

      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        final directory = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final fileName = event.pdfPath.split('/').last;
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        emit(TranscriptDownloaded(filePath));
      } else {
        emit(TranscriptDownloadsError(
          "Failed to download PDF: ${response.statusCode}",
        ));
      }
    } catch (e) {
      emit(TranscriptDownloadsError("Error downloading file: $e"));
    }
  }
}