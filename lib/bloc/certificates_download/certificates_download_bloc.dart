import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_aedp/bloc/certificates_download/certificate_item.dart';

part 'certificates_download_event.dart';
part 'certificates_download_state.dart';

class CertificatesDownloadBloc extends Bloc<CertificatesDownloadEvent, CertificatesDownloadState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CertificatesDownloadBloc() : super(CertificatesDownloadInitial()) {
    on<LoadCertificates>(_onLoadCertificates);
    on<DownloadCertificate>(_onDownloadCertificate);
     on<ReloadCertificates>(_onReloadCertificates);
  }
 

Future<void> _onReloadCertificates(
  ReloadCertificates event,
  Emitter<CertificatesDownloadState> emit,
) async {
  emit(CertificatesLoading());
  try {
    // Query ulang data sertifikat
    final certificatesSnapshot = await _firestore
        .collection('certificates')
        .where('father_name', isEqualTo: event.fatherName)
        .get();

    final certificates = certificatesSnapshot.docs.map((doc) {
      final data = doc.data();
      return CertificateItem(
        data['father_name'] ?? 'Unknown',
        data['file_name'] ?? 'Unknown File',
        data['pdf_path'] ?? '',
      );
    }).toList();

    emit(CertificatesLoaded(certificates));
  } catch (e) {
    emit(CertificatesDownloadError('Error reloading certificates: $e'));
  }
}

  Future<void> _onLoadCertificates(
    LoadCertificates event,
    Emitter<CertificatesDownloadState> emit,
  ) async {
    emit(CertificatesLoading());

    try {
      // Query certificates filtered by `father_name`
      final certificatesSnapshot = await _firestore
          .collection('certificates')
          .where('father_name', isEqualTo: event.fatherName)
          .get();

      final certificates = certificatesSnapshot.docs.map((doc) {
        final data = doc.data();
        return CertificateItem(
          data['father_name'] ?? 'Unknown',
          data['file_name'] ?? 'Unknown File',
          data['pdf_path'] ?? '',
        );
      }).toList();

      emit(CertificatesLoaded(certificates));
    } catch (e) {
      emit(CertificatesDownloadError('Error loading certificates: $e'));
    }
  }

  Future<void> _onDownloadCertificate(
    DownloadCertificate event,
    Emitter<CertificatesDownloadState> emit,
  ) async {
    emit(CertificatesDownloading());

    try {
      // Request storage permission
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          emit(CertificatesDownloadError("Storage permission is required to download files"));
          return;
        }
      }

      // Combine base URL with relative path
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(event.pdfPath).toString();

      // Download the PDF
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        // Determine download path
        final directory = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Save the file
        final fileName = event.pdfPath.split('/').last;
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
