import 'package:equatable/equatable.dart';
import 'package:project_aedp/bloc/library_download/library_download_state.dart';

abstract class LibraryDownloadState extends Equatable {
  const LibraryDownloadState();

  @override
  List<Object?> get props => [];
}

class LibraryDownloadInitial extends LibraryDownloadState {}

class LibraryDownloadLoading extends LibraryDownloadState {}

class LibraryDownloadLoaded extends LibraryDownloadState {
  final List<LibraryFile> files;

  const LibraryDownloadLoaded(this.files);

  @override
  List<Object?> get props => [files];
}

class LibraryDownloadFileSaved extends LibraryDownloadState {
  final String filePath;

  const LibraryDownloadFileSaved({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class LibraryDownloadError extends LibraryDownloadState {
  final String error;

  const LibraryDownloadError(this.error);

  @override
  List<Object?> get props => [error];
}
abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final Map<String, List<Map<String, dynamic>>> scheduleData;

  const ScheduleLoaded(this.scheduleData);

  @override
  List<Object?> get props => [scheduleData];
}

class ScheduleDownloaded extends ScheduleState {
  final String filePath;

  const ScheduleDownloaded(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class ScheduleError extends ScheduleState {
  final String error;

  const ScheduleError(this.error);

  @override
  List<Object?> get props => [error];
}