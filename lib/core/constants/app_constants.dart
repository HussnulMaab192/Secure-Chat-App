class AppConstants {
  // App name
  static const String appName = 'Secure Chat';
  
  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String authErrorMessage = 'Authentication failed. Please check your credentials.';
  static const String unknownErrorMessage = 'An unknown error occurred. Please try again.';
  
  // Success Messages
  static const String signUpSuccessMessage = 'Account created successfully!';
  static const String signInSuccessMessage = 'Signed in successfully!';
  static const String messageSentSuccessMessage = 'Message sent successfully!';
  
  // Validation Messages
  static const String emptyFieldError = 'This field cannot be empty';
  static const String invalidEmailError = 'Please enter a valid email address';
  static const String passwordLengthError = 'Password must be at least 8 characters long';
  static const String passwordMatchError = 'Passwords do not match';
  
  // Animation Durations
  static const int splashDuration = 2; // in seconds
}
