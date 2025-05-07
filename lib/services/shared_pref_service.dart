import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    await _prefs.setString('token', token);
  }

  static String? getToken() {
    return _prefs.getString('token');
  }

  static Future<void> removeToken() async {
    await _prefs.remove('token');
  }

  // User data keys
  static const String userIdKey = 'userId';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';
  static const String roleKey = 'role';

  static Future<void> setUserData(int id, String username, String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, id);
    await prefs.setString(usernameKey, username);
    await prefs.setString(emailKey, email);
    await prefs.setString(roleKey, role);
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt(userIdKey),
      'username': prefs.getString(usernameKey),
      'email': prefs.getString(emailKey),
      'role': prefs.getString(roleKey),
    };
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(roleKey);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    await prefs.remove(usernameKey);
    await prefs.remove(emailKey);
    await prefs.remove(roleKey);
  }
}
