class UserModel {
  final String username;
  final String role;

  UserModel({required this.username, required this.role});

  bool get isAllowed => role == 'CELEBRITY_SYSTEM_WORKER' || role == 'COMPANY';
}
