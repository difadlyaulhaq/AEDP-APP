abstract class InvoiceDownloadState {}

class InvoiceDownloadInitial extends InvoiceDownloadState {}

class InvoiceDownloading extends InvoiceDownloadState {}

class InvoiceDownloadError extends InvoiceDownloadState {
  final String message;
  InvoiceDownloadError(this.message);
}

class InvoiceDownloaded extends InvoiceDownloadState {
  final String filePath;
  InvoiceDownloaded(this.filePath);
}