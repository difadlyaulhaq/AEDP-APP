import 'package:equatable/equatable.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
 final List<Map<String, dynamic>> scheduleData;

  const ScheduleLoaded(this.scheduleData);


  @override
  List<Object?> get props => [scheduleData];
}

class ScheduleError extends ScheduleState {
  final String error;

  const ScheduleError(this.error);

  @override
  List<Object?> get props => [error];
}