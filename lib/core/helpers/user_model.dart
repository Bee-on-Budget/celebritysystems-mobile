class UserModel {
  final String username;
  final String role;
  final int? companyId;

  UserModel({
    required this.username,
    required this.role,
    required this.companyId,
  });

  bool get isAllowed => role == 'CELEBRITY_SYSTEM_WORKER' || role == 'COMPANY';
}
