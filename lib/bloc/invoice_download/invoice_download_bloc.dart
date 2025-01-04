import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aedp/bloc/invoice_download/invoice_download_event.dart';
import 'package:project_aedp/bloc/invoice_download/invoice_download_state.dart';

class InvoiceDownloadBloc extends Bloc<InvoiceDownloadEvent, InvoiceDownloadState> {
  InvoiceDownloadBloc() : super(InvoiceDownloadInitial()) {
    // Register the event handler for DownloadInvoice
    on<DownloadInvoice>(_onDownloadInvoice);
  }

  Future<void> _onDownloadInvoice(
    DownloadInvoice event,
    Emitter<InvoiceDownloadState> emit,
  ) async {
    emit(InvoiceDownloading());

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('payments')
          .doc(event.pdfPath)
          .get();

      if (snapshot.exists) {
        final downloadUrl = snapshot['url']; // Assuming Firestore stores a 'url' field
        // Simulate downloading logic
        await Future.delayed(const Duration(seconds: 2));
        emit(InvoiceDownloaded(downloadUrl));
      } else {
        emit(InvoiceDownloadError("File not found"));
      }
    } catch (e) {
      emit(InvoiceDownloadError("Error downloading file: $e"));
    }
  }
}
