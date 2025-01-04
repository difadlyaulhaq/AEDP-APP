abstract class InvoiceDownloadState {}

class InvoiceDownloadInitial extends InvoiceDownloadState {}

class InvoiceDownloading extends InvoiceDownloadState {}

class InvoiceDownloaded extends InvoiceDownloadState {
  final String downloadUrl;

  InvoiceDownloaded(this.downloadUrl);
}

class InvoiceDownloadError extends InvoiceDownloadState {
  final String error;

  InvoiceDownloadError(this.error);
}
