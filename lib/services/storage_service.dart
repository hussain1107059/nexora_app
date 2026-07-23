import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _loginStatusKey = 'login_status';
  static const String _baseUrlKey = 'base_url';
  static const String _tokenKey = 'token';
  static const String _idKey = 'id';
  static const String _accessIdKey = 'access_id';
  static const String _accessRoleKey = 'access_role';
  static const String _nameKey = 'name';
  static const String _permissionsKey = 'permissions';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoginStatus(bool value) async {
    await _prefs.setBool(_loginStatusKey, value);
  }

  static bool getLoginStatus() => _prefs.getBool(_loginStatusKey) ?? false;

  static Future<void> setBaseUrl(String value) async {
    await _prefs.setString(_baseUrlKey, value);
  }

  static String? getBaseUrl() => _prefs.getString(_baseUrlKey);

  static Future<void> setToken(String value) async {
    await _prefs.setString(_tokenKey, value);
  }

  static String? getToken() => _prefs.getString(_tokenKey);

  static Future<void> setId(String value) async {
    await _prefs.setString(_idKey, value);
  }

  static String? getId() => _prefs.getString(_idKey);

  static Future<void> setAccessId(String value) async {
    await _prefs.setString(_accessIdKey, value);
  }

  static String? getAccessId() => _prefs.getString(_accessIdKey);

  static Future<void> setAccessRole(String value) async {
    await _prefs.setString(_accessRoleKey, value);
  }

  static String? getAccessRole() => _prefs.getString(_accessRoleKey);

  static Future<void> setName(String value) async {
    await _prefs.setString(_nameKey, value);
  }

  static String? getName() => _prefs.getString(_nameKey);

  static Future<void> setPermissions(String value) async {
    await _prefs.setString(_permissionsKey, value);
  }

  static String? getPermissions() => _prefs.getString(_permissionsKey);

  static Future<void> clearAll() async {
    await _prefs.setBool(_loginStatusKey, false);
    await _prefs.remove(_baseUrlKey);
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_idKey);
    await _prefs.remove(_accessIdKey);
    await _prefs.remove(_accessRoleKey);
    await _prefs.remove(_nameKey);
    await _prefs.remove(_permissionsKey);
    await _clearAppCache();
  }

  static Future<void> _clearAppCache() async {
    if (kIsWeb) return;
    try {
      final dir = Directory.systemTemp;
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Cache clear error: $e');
    }
  }
}
