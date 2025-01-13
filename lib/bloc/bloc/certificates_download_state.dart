import 'package:equatable/equatable.dart';

sealed class CertificatesDownloadState extends Equatable {
  const CertificatesDownloadState();
  
  @override
  List<Object> get props => [];
}

final class CertificatesDownloadInitial extends CertificatesDownloadState {}
final class CertificatesDownloading extends CertificatesDownloadState {}

final class CertificatesDownloaded extends CertificatesDownloadState {
  final String filePath;

  const CertificatesDownloaded(this.filePath);

  @override
  List<Object> get props => [filePath];
}

final class CertificatesDownloadError extends CertificatesDownloadState {
  final String message;

  const CertificatesDownloadError(this.message);

  @override
  List<Object> get props => [message];
}