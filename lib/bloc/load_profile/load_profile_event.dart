abstract class LoadProfileEvent {
  const LoadProfileEvent();
}

class LoadUserProfile extends LoadProfileEvent {
  final num id;
  LoadUserProfile({required this.id});
}
