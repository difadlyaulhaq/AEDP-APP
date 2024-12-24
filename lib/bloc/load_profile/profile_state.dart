import 'package:equatable/equatable.dart';

abstract class LoadProfileState extends Equatable {
  const LoadProfileState();

  @override
  List<Object?> get props => [];
}

class LoadProfileInitial extends LoadProfileState {}

class LoadProfileLoading extends LoadProfileState {}

class LoadProfileLoaded extends LoadProfileState {
  final Map<String, dynamic> profileData;

  const LoadProfileLoaded({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}

class LoadProfileError extends LoadProfileState {
  final String errorMessage;

  const LoadProfileError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}