abstract class InvoiceDownloadEvent {}

class DownloadInvoice extends InvoiceDownloadEvent {
  final String pdfPath;
  DownloadInvoice(this.pdfPath);
}