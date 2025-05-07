import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/shared_pref_service.dart';
import '../utils/toast_util.dart';

class AdminProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> getUsers() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await SharedPrefService.getToken();
      if (token == null) {
        ToastUtil.showErrorToast('Please login again');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiConstants.adminUsers),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _users = data.map((json) => User.fromJson(json)).toList();
        notifyListeners();
      } else {
        ToastUtil.showErrorToast('Failed to load users');
      }
    } catch (error) {
      debugPrint('Get Users Error: $error');
      ToastUtil.showErrorToast('Error loading users');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserRole(int userId, String newRole) async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await SharedPrefService.getToken();
      if (token == null) {
        ToastUtil.showErrorToast('Please login again');
        return;
      }

      final response = await http.patch(
        Uri.parse(ApiConstants.adminUpdateRole(userId.toString())),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'role': newRole}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        ToastUtil.showSuccessToast(responseData['message']);
        await getUsers(); // Refresh users list
      } else {
        ToastUtil.showErrorToast('Failed to update user role');
      }
    } catch (error) {
      debugPrint('Update Role Error: $error');
      ToastUtil.showErrorToast('Error updating role');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNonAdminUsers() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await SharedPrefService.getToken();
      if (token == null) {
        ToastUtil.showErrorToast('Please login again');
        return;
      }

      final response = await http.delete(
        Uri.parse(ApiConstants.adminDeleteNonAdmins),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        ToastUtil.showSuccessToast(
          '${responseData['usersDeleted']} users deleted successfully',
        );
        await getUsers(); // Refresh users list
      } else {
        ToastUtil.showErrorToast('Failed to delete users');
      }
    } catch (error) {
      debugPrint('Delete Users Error: $error');
      ToastUtil.showErrorToast('Error deleting users');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
