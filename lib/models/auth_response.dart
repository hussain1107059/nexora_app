class AuthResponse {
  final bool success;
  final String? message;
  final String? companyBaseUrl;
  final String? token;

  const AuthResponse({
    required this.success,
    this.message,
    this.companyBaseUrl,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    bool ok;
    if (json['success'] is bool) {
      ok = json['success'] as bool;
    } else if (json['status'] != null) {
      ok = json['status'].toString().toLowerCase() == 'success';
    } else if (json['token'] != null) {
      ok = true;
    } else if (json['company_base_url'] != null) {
      ok = true;
    } else {
      ok = false;
    }

    return AuthResponse(
      success: ok,
      message: json['message']?.toString() ??
          json['error']?.toString() ??
          json['detail']?.toString(),
      companyBaseUrl: json['company_base_url']?.toString(),
      token: json['token']?.toString(),
    );
  }

  @override
  String toString() =>
      'AuthResponse(success: $success, message: $message, companyBaseUrl: $companyBaseUrl, token: ${token != null ? '***' : null})';
}
