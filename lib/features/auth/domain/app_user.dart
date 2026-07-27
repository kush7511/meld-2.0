class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.username,
    this.photoUrl,
    this.bio,
    this.isOnline = false,
    this.lastActive,
  });

  final String id;
  final String? email;
  final String? displayName;
  final String username;
  final String? photoUrl;
  final String? bio;
  final bool isOnline;
  final DateTime? lastActive;
}
