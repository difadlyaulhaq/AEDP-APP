class ScheduleEvent {
  List<Object?> get props => [];
}

class DownloadSchedule extends ScheduleEvent {
  final String filePath;

  DownloadSchedule({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class FetchSchedule extends ScheduleEvent {
  final String userId;

  FetchSchedule({required this.userId});

  @override
  List<Object?> get props => [userId];
}