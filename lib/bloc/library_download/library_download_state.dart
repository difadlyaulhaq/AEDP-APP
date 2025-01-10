import 'dart:io';

abstract class LibraryDownloadState {}

class LibraryDownloadInitial extends LibraryDownloadState {}

class LibraryDownloadLoading extends LibraryDownloadState {}

class LibraryDownloadError extends LibraryDownloadState {
  final String message;

  LibraryDownloadError(this.message);
}

class LibraryDownloadSuccess extends LibraryDownloadState {
  final List<File> files; // Assuming File is a class that holds file information

  LibraryDownloadSuccess({required this.files});
}

class LibraryDownloadLoaded extends LibraryDownloadState {
  final List<LibraryFile> files;
  final String? filePath;  // Optional parameter for file path

  LibraryDownloadLoaded({this.files = const [], this.filePath});
}


class LibraryFile {
  final String name;
  final String filePath;

  LibraryFile({required this.name, required this.filePath});
}
