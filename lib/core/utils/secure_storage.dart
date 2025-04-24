import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class SecureStorage {
  final SharedPreferences _sharedPreferences;

  SecureStorage(this._sharedPreferences);

  // Save token
  Future<void> saveToken(String token) async {
    try {
      await _sharedPreferences.setString(AppConstants.tokenKey, token);
    } catch (e) {
      throw CacheException('Failed to save token: ${e.toString()}');
    }
  }

  // Get token
  Future<String?> getToken() async {
    try {
      return _sharedPreferences.getString(AppConstants.tokenKey);
    } catch (e) {
      throw CacheException('Failed to get token: ${e.toString()}');
    }
  }

  // Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final userDataString = json.encode(userData);
      await _sharedPreferences.setString(AppConstants.userKey, userDataString);
    } catch (e) {
      throw CacheException('Failed to save user data: ${e.toString()}');
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userDataString = _sharedPreferences.getString(AppConstants.userKey);
      if (userDataString != null) {
        return json.decode(userDataString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get user data: ${e.toString()}');
    }
  }

  // Clear all data (for logout)
  Future<void> clearAll() async {
    try {
      await _sharedPreferences.remove(AppConstants.tokenKey);
      await _sharedPreferences.remove(AppConstants.userKey);
    } catch (e) {
      throw CacheException('Failed to clear data: ${e.toString()}');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null;
    } catch (e) {
      return false;
    }
  }
}
