import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aedp/bloc/invoice_download/invoice_download_event.dart';
import 'package:project_aedp/bloc/invoice_download/invoice_download_state.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

      if (snapshot.exists) {
        final pdfPath = snapshot['pdf_path']; // Get the relative path
        if (pdfPath == null || pdfPath.isEmpty) {
          emit(InvoiceDownloadError("Invalid PDF path in Firestore"));
          return;
        }

        // Combine base URL with relative path
        final baseUrl = "https://gold-tiger-632820.hostingersite.com/";
        final downloadUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();

        // Download the PDF
        final response = await http.get(Uri.parse(downloadUrl));
        if (response.statusCode == 200) {
          // Save the file locally
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/${pdfPath.split('/').last}';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          emit(InvoiceDownloaded(filePath));
        } else {
          emit(InvoiceDownloadError("Failed to download PDF: ${response.statusCode}"));
        }
      } else {
        emit(InvoiceDownloadError("File not found in Firestore"));
      }
    } catch (e) {
      emit(InvoiceDownloadError("Error downloading file: $e"));
    }
  }
}
