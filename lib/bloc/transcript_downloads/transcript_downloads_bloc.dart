import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_aedp/bloc/transcript_downloads/transcript_item.dart';

part 'transcript_downloads_event.dart';
part 'transcript_downloads_state.dart';

class TranscriptDownloadsBloc extends Bloc<TranscriptDownloadsEvent, TranscriptDownloadsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TranscriptDownloadsBloc() : super(TranscriptDownloadsInitial()) {
    on<LoadTranscripts>(_onLoadTranscripts);
    on<ReloadTranscripts>(_onReloadTranscripts);
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
}