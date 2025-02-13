import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_aedp/bloc/certificates_download/certificate_item.dart';

part 'certificates_download_event.dart';
part 'certificates_download_state.dart';

class CertificatesDownloadBloc extends Bloc<CertificatesDownloadEvent, CertificatesDownloadState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CertificatesDownloadBloc() : super(CertificatesDownloadInitial()) {
    on<LoadCertificates>(_onLoadCertificates);
    on<ReloadCertificates>(_onReloadCertificates);
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
}