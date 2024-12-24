
abstract class LoadProfileEvent {
  const LoadProfileEvent();
}

class LoadUserProfile extends LoadProfileEvent {
  final String userId;
  final String role;

  const LoadUserProfile({required this.userId, required this.role});
}