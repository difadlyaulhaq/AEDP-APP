abstract class InvoiceDownloadState {}

class InvoiceDownloadInitial extends InvoiceDownloadState {}

class InvoiceDownloading extends InvoiceDownloadState {}

class InvoiceDownloaded extends InvoiceDownloadState {
  final String filePath;

  InvoiceDownloaded(this.filePath);
}

class InvoiceDownloadError extends InvoiceDownloadState {
  final String message;

  InvoiceDownloadError(this.message);
}
