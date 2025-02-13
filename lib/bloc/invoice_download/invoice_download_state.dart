
import 'package:equatable/equatable.dart';

abstract class InvoiceDownloadState extends Equatable {
  const InvoiceDownloadState();

  @override
  List<Object?> get props => [];
}

class InvoiceDownloadInitial extends InvoiceDownloadState {}

class InvoiceDownloading extends InvoiceDownloadState {}

class InvoiceDownloadSuccess extends InvoiceDownloadState {
  final String pdfPath;

  const InvoiceDownloadSuccess(this.pdfPath);

  @override
  List<Object?> get props => [pdfPath];
}

class InvoiceDownloadError extends InvoiceDownloadState {
  final String message;

  const InvoiceDownloadError(this.message);

  @override
  List<Object?> get props => [message];
}