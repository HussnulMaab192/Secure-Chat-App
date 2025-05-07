import 'dart:convert';
import 'package:chat_app_secure_programming/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../utils/toast_util.dart';
import '../services/shared_pref_service.dart';
import './chat_provider.dart';
import '../constants/api_constants.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _signupLoading = false;
  bool _signinLoading = false;
  
  String? get token => _token;
  bool get signupLoading => _signupLoading;
  bool get signinLoading => _signinLoading;

  Future<void> signup(String username, String email, String password) async {
    try {
      _signupLoading = true;
      notifyListeners();

      debugPrint('Attempting signup to: ${ApiConstants.signup}');
      
      final response = await http.post(
        Uri.parse(ApiConstants.signup),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      debugPrint('Response body: ${response.body}');

      _signupLoading = false;
      notifyListeners();

      if (response.body.isEmpty) {
        debugPrint('Empty response received');
        ToastUtil.showErrorToast('Server returned empty response');
        return;
      }

      final responseData = json.decode(response.body);
      debugPrint('Signup Response: $responseData');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = responseData['token'];
        ToastUtil.showSuccessToast("User created successfully!");
        notifyListeners();
      } else {
        debugPrint('Signup Error: ${responseData['message']}');
        ToastUtil.showErrorToast(responseData['message'] ?? 'Something went wrong');
      }
    } catch (error) {
      _signupLoading = false;
      notifyListeners();
      debugPrint('Signup Exception: $error');
      
      if (error is FormatException) {
        ToastUtil.showErrorToast('Invalid response from server');
      } else {
        ToastUtil.showErrorToast('Network error. Check your connection');
      }
    }
  }

  Future<void> signin(String email, String password) async {
    try {
      _signinLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(ApiConstants.signin),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      _signinLoading = false;
      notifyListeners();

      final responseData = json.decode(response.body);
      debugPrint('Signin Response: $responseData');
      
      if (response.statusCode == 200) {
        _token = responseData['token'];
        final userData = responseData['user'];
        
        // Store token and user data with role
        await SharedPrefService.setToken(_token!);
        await SharedPrefService.setUserData(
          userData['id'],
          userData['username'],
          userData['email'],
          userData['role'],
        );
        
        ToastUtil.showSuccessToast("Signed in successfully!");
        notifyListeners();
      } else {
        debugPrint('Signin Error: ${responseData['message']}');
        ToastUtil.showErrorToast(responseData['message'] ?? 'Something went wrong');
      }
    } catch (error) {
      _signinLoading = false;
      notifyListeners();
      debugPrint('Signin Exception: $error');
      ToastUtil.showErrorToast('Network error occurred. Please try again.');
    }
  }

  Future<void> signout(BuildContext context) async {
    try {
      await SharedPrefService.removeToken();
      await SharedPrefService.clearUserData();
      _token = null;
      
      // Cleanup chat provider
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.cleanupOnSignOut();
      
      notifyListeners();
      
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
    } catch (error) {
      debugPrint('Signout Exception: $error');
      ToastUtil.showErrorToast('Error signing out. Please try again.');
    }
  }

  Future<bool> isTokenValid() async {
    try {
      final token = await SharedPrefService.getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse(ApiConstants.verifyToken),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);
      return responseData['valid'] ?? false;
    } catch (error) {
      debugPrint('Token Validation Error: $error');
      return false;
    }
  }
}
