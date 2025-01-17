abstract class LibraryDownloadEvent {}

class DownloadFile extends LibraryDownloadEvent {
  final String filePath;

  DownloadFile(this.filePath);
}
class LoadLibraryFiles extends LibraryDownloadEvent {
  final String userId;
  LoadLibraryFiles(this.userId);
}


