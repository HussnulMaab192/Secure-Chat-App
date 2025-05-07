import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Your Mac's IP address that Android device can access
  static const String baseUrl = 'http://192.168.89.181:5001';
  
  // Auth endpoints
  static const String signup = '$baseUrl/signup';
  static const String signin = '$baseUrl/signin';
  static const String verifyToken = '$baseUrl/verify-token';
  
  // Chat endpoints
  static const String messages = '$baseUrl/messages';
  static const String clearChat = '$baseUrl/clearchat';

  // Admin endpoints
  static const String adminUsers = '$baseUrl/admin/users';
  static String adminUpdateRole(String userId) => '$baseUrl/admin/users/$userId/role';
  static const String adminDeleteNonAdmins = '$baseUrl/admin/users/non-admin';
}
