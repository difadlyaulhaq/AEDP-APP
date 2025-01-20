part of 'transcript_downloads_bloc.dart';

abstract class TranscriptDownloadsEvent extends Equatable {
  const TranscriptDownloadsEvent();

  @override
  List<Object> get props => [];
}

class LoadTranscriptFiles extends TranscriptDownloadsEvent {
  final String userId;

  const LoadTranscriptFiles(this.userId);

  @override
  List<Object> get props => [userId];
}

class DownloadTranscriptFile extends TranscriptDownloadsEvent {
  final String filePath;

  const DownloadTranscriptFile(this.filePath);

  @override
  List<Object> get props => [filePath];
}