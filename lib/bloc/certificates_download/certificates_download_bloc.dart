import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'certificates_download_event.dart';
part 'certificates_download_state.dart';

class CertificatesDownloadBloc extends Bloc<CertificatesDownloadEvent, CertificatesDownloadState> {
  CertificatesDownloadBloc() : super(CertificatesDownloadInitial()) {
    on<DownloadCertificate>(_onDownloadCertificate);
  }

  Future<void> _onDownloadCertificate(
    DownloadCertificate event,
    Emitter<CertificatesDownloadState> emit,
  ) async {
    emit(CertificatesDownloading());

    try {
      // Check storage permission
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          emit(CertificatesDownloadError("Storage permission is required to download files"));
          return;
        }
      }

      // Fetch PDF data from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('certificates')
          .doc(event.pdfPath)
          .get();

      if (!snapshot.exists) {
        emit(CertificatesDownloadError("File not found in Firestore"));
        return;
      }

      final pdfPath = snapshot.data()?['pdf_path'] as String?;
      if (pdfPath == null || pdfPath.isEmpty || !pdfPath.endsWith('.pdf')) {
        emit(CertificatesDownloadError("Invalid PDF path in Firestore"));
        return;
      }

      // Combine base URL with relative path
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();

      // Download the PDF
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        // Get the downloads directory
        final directory = Platform.isAndroid 
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final fileName = pdfPath.split('/').last;
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        emit(CertificatesDownloaded(filePath));
      } else {
        emit(CertificatesDownloadError(
          "Failed to download PDF: ${response.statusCode}",
        ));
      }
    } catch (e) {
      emit(CertificatesDownloadError("Error downloading file: $e"));
    }
  }
}