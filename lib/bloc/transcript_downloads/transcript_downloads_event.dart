part of 'transcript_downloads_bloc.dart';

abstract class TranscriptDownloadsEvent extends Equatable {
  const TranscriptDownloadsEvent();

  @override
  List<Object> get props => [];
}

class LoadTranscripts extends TranscriptDownloadsEvent {
  final String fatherName;

  const LoadTranscripts(this.fatherName);

  @override
  List<Object> get props => [fatherName];
}

class DownloadTranscript extends TranscriptDownloadsEvent {
  final String fatherName;
  final String pdfPath;
  final BuildContext context;

  const DownloadTranscript(this.fatherName, this.pdfPath, this.context);
  
  @override
  List<Object> get props => [fatherName, pdfPath, context];
}

class ReloadTranscripts extends TranscriptDownloadsEvent {
  final String fatherName;

  const ReloadTranscripts(this.fatherName);

  @override
  List<Object> get props => [fatherName];
}