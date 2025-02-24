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
      final snapshot = await _firestore.collection('library').get();
      if(snapshot.docs.isEmpty) {
        emit(LibraryDownloadError("No library files available"));
        return;
      }
      final files = snapshot.docs.map((doc) {
        final data = doc.data();
        return LibraryFile(
          name: data['name'] as String? ?? 'Unknown',
          filePath: data['file_path'] as String? ?? '',
        );
      }).toList();
      emit(LibraryDownloadLoaded(files: files));
          } catch (e) {
      emit(LibraryDownloadError("Error loading library files: $e"));
    }
  }
}