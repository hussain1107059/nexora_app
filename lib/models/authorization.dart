class Authorization {
  final String user;
  final String accessType;
  final String userName;
  final String password;
  final String status;

  const Authorization({
    required this.user,
    required this.accessType,
    required this.userName,
    required this.password,
    required this.status,
  });

  String get name => userName.isNotEmpty ? userName : user;
}
