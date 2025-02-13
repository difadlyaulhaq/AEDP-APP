
import 'package:equatable/equatable.dart';

abstract class InvoiceDownloadEvent extends Equatable {
  const InvoiceDownloadEvent();

  @override
  List<Object?> get props => [];
}

class DownloadInvoice extends InvoiceDownloadEvent {
  final String pdfPath;

  const DownloadInvoice(this.pdfPath);

  @override
  List<Object?> get props => [pdfPath];
}