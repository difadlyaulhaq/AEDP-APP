part of 'transcript_downloads_bloc.dart';

abstract class TranscriptDownloadsState extends Equatable {
  const TranscriptDownloadsState();

  @override
  List<Object> get props => [];
}

class TranscriptDownloadsInitial extends TranscriptDownloadsState {}

class TranscriptsLoading extends TranscriptDownloadsState {}

class TranscriptsDownloading extends TranscriptDownloadsState {}

class TranscriptsLoaded extends TranscriptDownloadsState {
  final List<TranscriptItem> transcripts;
  
  const TranscriptsLoaded({required this.transcripts});

  @override
  List<Object> get props => [transcripts];
}

class TranscriptDownloaded extends TranscriptDownloadsState {
  final String filePath;

  const TranscriptDownloaded(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class TranscriptDownloadsError extends TranscriptDownloadsState {
  final String message;

  const TranscriptDownloadsError(this.message);

  @override
  List<Object> get props => [message];
}