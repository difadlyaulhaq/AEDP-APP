part of 'certificates_download_bloc.dart';

sealed class CertificatesDownloadEvent extends Equatable {
  const CertificatesDownloadEvent();

  @override
  List<Object> get props => [];
}
class DownloadCertificate extends CertificatesDownloadEvent {
  final String pdfPath;

  DownloadCertificate(this.pdfPath);
}