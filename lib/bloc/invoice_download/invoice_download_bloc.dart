import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
      // Check storage permission
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          emit(InvoiceDownloadError("Storage permission is required to download files"));
          return;
        }
      }

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

      // Combine base URL with relative path
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();

      // Download the PDF
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        // Get the downloads directory for Android or documents directory for iOS
        final directory = Platform.isAndroid 
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();

        // Create directory if it doesn't exist
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Save the file
        final fileName = pdfPath.split('/').last;
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        emit(InvoiceDownloaded(filePath));
      } else {
        emit(InvoiceDownloadError(
          "Failed to download PDF: ${response.statusCode}",
        ));
      }
    } catch (e) {
      emit(InvoiceDownloadError("Error downloading file: $e"));
    }
  }
}
