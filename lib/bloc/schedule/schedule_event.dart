import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class FetchSchedule extends ScheduleEvent {
  final String userId;

  const FetchSchedule({required this.userId});

  @override
  List<Object?> get props => [userId];
}