part of 'transcript_downloads_bloc.dart';

sealed class TranscriptDownloadsState extends Equatable {
  const TranscriptDownloadsState();
  
  @override
  List<Object> get props => [];
}

final class TranscriptDownloadsInitial extends TranscriptDownloadsState {}

final class TranscriptDownloadsLoading extends TranscriptDownloadsState {}

final class TranscriptDownloadsLoaded extends TranscriptDownloadsState {
  final List<TranscriptFile> files;

  const TranscriptDownloadsLoaded({required this.files});

  @override
  List<Object> get props => [files];
}

final class TranscriptDownloadsError extends TranscriptDownloadsState {
  final String message;

  const TranscriptDownloadsError(this.message);

  @override
  List<Object> get props => [message];
}

final class TranscriptDownloadSuccess extends TranscriptDownloadsState {
  final String filePath;

  const TranscriptDownloadSuccess(this.filePath);

  @override
  List<Object> get props => [filePath];
}

final class TranscriptDownloadInProgress extends TranscriptDownloadsState {
  const TranscriptDownloadInProgress();

  @override
  List<Object> get props => [];
}
