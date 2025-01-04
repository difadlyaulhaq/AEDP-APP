abstract class LoadProfileEvent {
  const LoadProfileEvent();
}

class LoadUserProfile extends LoadProfileEvent {
  final String id;
  LoadUserProfile({required this.id});
}
