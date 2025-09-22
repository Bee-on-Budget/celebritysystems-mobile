// class UserModel {
//   final String username;
//   final String role;
//   final int? companyId;
//   final int? userId;

//   UserModel(
//       {required this.username,
//       required this.role,
//       required this.companyId,
//       required this.userId});

//   bool get isAllowed => role == 'CELEBRITY_SYSTEM_WORKER' || role == 'COMPANY';
// }

class UserModel {
  final String username;
  final String role;
  final int? companyId;
  final int? userId;
  final bool? canRead;
  final bool? canEdit;

  UserModel({
    required this.username,
    required this.role,
    required this.companyId,
    required this.userId,
    this.canRead,
    this.canEdit,
  });

  bool get isAllowed =>
      role == 'CELEBRITY_SYSTEM_WORKER' ||
      role == 'COMPANY' ||
      role == 'SUPERVISOR';

  @override
  String toString() {
    return 'UserModel(username: $username, role: $role, companyId: $companyId, userId: $userId, isAllowed: $isAllowed, canRead: $canRead, canEdit: $canEdit)';
  }

  // Factory constructor with better type handling
  factory UserModel.fromPayload(Map<String, dynamic> payload) {
    return UserModel(
        username: payload['username']?.toString() ?? '',
        role: payload['role']?.toString() ?? '',
        companyId: payload['companyId'] is String
            ? int.tryParse(payload['companyId'])
            : payload['companyId'],
        userId: payload['sub'] is String
            ? int.tryParse(payload['sub'])
            : payload['sub'],
        canRead: payload['canRead'] is bool ? payload['canRead'] : null,
        canEdit: payload['canEdit'] is bool ? payload['canEdit'] : null);
  }
}
