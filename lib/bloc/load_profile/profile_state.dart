abstract class LoadProfileState {}

class LoadProfileInitial extends LoadProfileState {}
class LoadProfileLoading extends LoadProfileState {}

class LoadProfileLoaded extends LoadProfileState {
  final Map<String, dynamic> profileData;
  LoadProfileLoaded({required this.profileData});
}

class LoadProfileError extends LoadProfileState {
  final String message;
  LoadProfileError(this.message);
}