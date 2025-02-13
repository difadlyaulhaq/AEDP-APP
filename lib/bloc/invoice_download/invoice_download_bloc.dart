import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:project_aedp/bloc/invoice_download/invoice_download_event.dart';
import 'package:project_aedp/bloc/invoice_download/invoice_download_state.dart';


class InvoiceDownloadBloc extends Bloc<InvoiceDownloadEvent, InvoiceDownloadState> {
  InvoiceDownloadBloc() : super(InvoiceDownloadInitial()) {
    on<DownloadInvoice>(_onDownloadInvoice);
  }

  Future<void> _onDownloadInvoice(
    DownloadInvoice event,
    Emitter<InvoiceDownloadState> emit,
  ) async {
    emit(InvoiceDownloading());

    try {
      // Fetch PDF data from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('payments')
          .doc(event.pdfPath)
          .get();

      if (!snapshot.exists) {
        emit(InvoiceDownloadError("File not found in Firestore"));
        return;
      }

      final pdfPath = snapshot.data()?['pdf_path'] as String?; // Safer type casting
      if (pdfPath == null || pdfPath.isEmpty || !pdfPath.endsWith('.pdf')) {
        emit(InvoiceDownloadError("Invalid PDF path in Firestore"));
        return;
      }

      emit(InvoiceDownloadSuccess(pdfPath));
    } catch (e) {
      emit(InvoiceDownloadError("Error downloading file: $e"));
    }
  }
}