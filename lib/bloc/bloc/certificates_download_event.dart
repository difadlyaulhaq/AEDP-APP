import 'package:equatable/equatable.dart';

class CertificatesDownloadEvent extends Equatable {
  const CertificatesDownloadEvent();

  List<Object> get props => [];
}
class DownloadCertificate extends CertificatesDownloadEvent {
  final String pdfPath;

  const DownloadCertificate(this.pdfPath);

  @override
  List<Object> get props => [pdfPath];
}