import 'dart:io';

abstract class LibraryDownloadState {}

class LibraryDownloadInitial extends LibraryDownloadState {}

class LibraryDownloadLoading extends LibraryDownloadState {}

class LibraryDownloadError extends LibraryDownloadState {
  final String message;

  LibraryDownloadError(this.message);
}

class LibraryDownloadSuccess extends LibraryDownloadState {
  final String filePath;

  LibraryDownloadSuccess(this.filePath);
}

class LibraryDownloadLoaded extends LibraryDownloadState {
  final List<LibraryFile> files;

  LibraryDownloadLoaded({this.files = const []});
}

class LibraryFile {
  final String name;
  final String filePath;

  LibraryFile({required this.name, required this.filePath});
}
