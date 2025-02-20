// part of 'certificates_download_bloc.dart';

// sealed class CertificatesDownloadEvent extends Equatable {
//   const CertificatesDownloadEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoadCertificates extends CertificatesDownloadEvent {
//   final String fatherName;

//   const LoadCertificates(this.fatherName);

//   @override
//   List<Object> get props => [fatherName];
// }

// class DownloadCertificate extends CertificatesDownloadEvent {
//   final String fatherName;

//   final String pdfPath;
//   final BuildContext context;

//   const DownloadCertificate(this.fatherName, this.pdfPath, this.context);
//   @override
//   List<Object> get props => [fatherName, pdfPath, context];
// }

// class ReloadCertificates extends CertificatesDownloadEvent {
//   final String fatherName;

//   const ReloadCertificates(this.fatherName);

//   @override
//   List<Object> get props => [fatherName];
// }