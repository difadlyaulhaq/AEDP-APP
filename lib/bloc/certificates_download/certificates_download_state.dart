part of 'certificates_download_bloc.dart';

sealed class CertificatesDownloadState extends Equatable {
  const CertificatesDownloadState();
  
  @override
  List<Object> get props => [];
}

class CertificatesDownloadInitial extends CertificatesDownloadState {}

class CertificatesLoading extends CertificatesDownloadState {}

class CertificatesDownloading extends CertificatesDownloadState {}

class CertificatesLoaded extends CertificatesDownloadState {
  final List<CertificateItem> certificates;
  
  const CertificatesLoaded(this.certificates);
  
  @override
  List<Object> get props => [certificates];
}

class CertificatesDownloaded extends CertificatesDownloadState {
  final String filePath;
  
  const CertificatesDownloaded(this.filePath);
  
  @override
  List<Object> get props => [filePath];
}

class CertificatesDownloadError extends CertificatesDownloadState {
  final String message;
  
  const CertificatesDownloadError(this.message);
  
  @override
  List<Object> get props => [message];
}

