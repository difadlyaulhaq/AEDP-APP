abstract class LibraryDownloadEvent {}

class DownloadFile extends LibraryDownloadEvent {
  final String filePath;
 final String userId; // Include userId for reloading data

  DownloadFile(this.filePath, this.userId);
}

class LoadLibraryFiles extends LibraryDownloadEvent {
  final String userId;

  LoadLibraryFiles(this.userId);
}
