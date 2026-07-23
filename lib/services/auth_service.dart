import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/auth_response.dart';
import 'storage_service.dart';

class AuthService {
  static const String _baseUrl = 'https://badhonbyte.com/api/auth';

  static Future<AuthResponse> login(
      String company, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'company': company,
          'email': email,
          'password': password,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return AuthResponse(success: false, message: e.toString());
    }
  }

  static Future<AuthResponse> fetchToken(String baseUrl) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/token'),
      );
      return _handleResponse(response);
    } catch (e) {
      return AuthResponse(success: false, message: e.toString());
    }
  }

  static Future<AuthResponse> loginWithToken(
      String baseUrl, String token, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return AuthResponse(success: false, message: e.toString());
    }
  }

  static Future<bool> fullAuthFlow(
      String company, String email, String password) async {
    try {
      debugPrint('\n===== STEP 1: Get base URL =====');
      final step1 = await login(company, email, password);
      debugPrint('Step 1 response: $step1');

      if (!step1.success || step1.companyBaseUrl == null) {
        debugPrint('Failed: No company_base_url in response');
        return false;
      }

      final baseUrl = step1.companyBaseUrl!;
      await StorageService.setBaseUrl(baseUrl);
      debugPrint('Saved base_url: $baseUrl');

      debugPrint('\n===== STEP 2: Fetch token =====');
      final step2 = await fetchToken(baseUrl);
      debugPrint('Step 2 response: $step2');

      if (!step2.success || step2.token == null) {
        debugPrint('Failed: No token in response');
        return false;
      }

      final token = step2.token!;
      await StorageService.setToken(token);
      debugPrint('Saved token: $token');

      debugPrint('\n===== STEP 3: Login with token =====');
      final step3 = await loginWithToken(baseUrl, token, email, password);
      debugPrint('Step 3 response: $step3');

      if (!step3.success || step3.token == null) {
        debugPrint('Failed: Login with token unsuccessful');
        return false;
      }

      final finalToken = step3.token!;
      await StorageService.setToken(finalToken);
      debugPrint('Saved final token: $finalToken');

      _decodeAndSaveToken(finalToken);

      await StorageService.setLoginStatus(true);
      debugPrint('Login status set to: true');

      return true;
    } catch (e) {
      debugPrint('Auth flow error: $e');
      return false;
    }
  }

  static void _decodeAndSaveToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return;

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final data = jsonDecode(payload);

      debugPrint('Decoded token payload: $data');

      if (data['id'] != null) StorageService.setId(data['id'].toString());
      if (data['access_id'] != null) {
        StorageService.setAccessId(data['access_id'].toString());
      }
      if (data['access_role'] != null) {
        StorageService.setAccessRole(data['access_role'].toString());
      }
      if (data['name'] != null) StorageService.setName(data['name'].toString());

      debugPrint('Saved: id=${data['id']}, access_id=${data['access_id']}, '
          'access_role=${data['access_role']}, name=${data['name']}');
    } catch (e) {
      debugPrint('Failed to decode token: $e');
    }
  }

  static Future<void> fetchPermissions() async {
    try {
      final baseUrl = StorageService.getBaseUrl();
      final token = StorageService.getToken();

      debugPrint('\n===== FETCH PERMISSIONS =====');
      debugPrint('Base URL from storage: $baseUrl');
      debugPrint('Token from storage: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');

      if (baseUrl == null || token == null) {
        debugPrint('SKIP: baseUrl or token is null');
        return;
      }

      final url = '$baseUrl/api/auth/user/permissions';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      debugPrint('URL: $url');
      debugPrint('Headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final permissions = json['permissions'] ?? json;
        final permissionsStr = jsonEncode(permissions);
        await StorageService.setPermissions(permissionsStr);
        debugPrint('PERMISSIONS SAVED SUCCESSFULLY: $permissionsStr');
      } else {
        debugPrint('FAILED: Status code is ${response.statusCode}, not 200');
      }
    } catch (e) {
      debugPrint('FETCH PERMISSIONS ERROR: $e');
    }
  }

  static AuthResponse _handleResponse(http.Response response) {
    debugPrint('Status: ${response.statusCode}');
    debugPrint('Body: ${response.body}');

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResponse.fromJson(json);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Failed to parse response: $e',
      );
    }
  }
}
