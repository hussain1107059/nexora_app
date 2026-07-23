class AuthRequest {
  final String company;
  final String email;
  final String password;

  const AuthRequest({
    required this.company,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'company': company,
        'email': email,
        'password': password,
      };
}
