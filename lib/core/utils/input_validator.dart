import '../constants/app_constants.dart';

class InputValidator {
  // Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyFieldError;
    }
    
    // Email regex pattern
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (!emailRegex.hasMatch(value)) {
      return AppConstants.invalidEmailError;
    }
    
    return null;
  }
  
  // Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyFieldError;
    }
    
    if (value.length < 8) {
      return AppConstants.passwordLengthError;
    }
    
    return null;
  }
  
  // Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyFieldError;
    }
    
    if (value != password) {
      return AppConstants.passwordMatchError;
    }
    
    return null;
  }
  
  // Validate username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyFieldError;
    }
    
    return null;
  }
  
  // Validate message
  static String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyFieldError;
    }
    
    return null;
  }
}
