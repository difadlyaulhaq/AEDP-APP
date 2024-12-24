import 'package:equatable/equatable.dart';

class LoadProfileEvent extends Equatable {
  final String teacherId;

  const LoadProfileEvent({required this.teacherId});

  @override
  List<Object?> get props => [teacherId];
}
