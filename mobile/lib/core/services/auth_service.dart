import 'package:pyqachu/core/models/api_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  static Future<void> saveAuthData(String? token, UserProfile? user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token ?? '');

    if (user != null) {
      final userMap = {
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'role': user.role,
      };
      await prefs.setString(_userKey, jsonEncode(userMap));
    } else {
      await prefs.remove(_userKey);
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}