abstract class LoadProfileEvent {
  const LoadProfileEvent();
}

class LoadUserProfile extends LoadProfileEvent {
  final String email;
  LoadUserProfile({required this.email});
}
