// Base Exception
class AppException implements Exception {
  final String message;
  
  AppException(this.message);
  
  @override
  String toString() => message;
}

// Server Exception
class ServerException extends AppException {
  ServerException([String message = 'Server error occurred']) : super(message);
}

// Network Exception
class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred']) : super(message);
}

// Authentication Exception
class AuthException extends AppException {
  AuthException([String message = 'Authentication error occurred']) : super(message);
}

// Cache Exception
class CacheException extends AppException {
  CacheException([String message = 'Cache error occurred']) : super(message);
}

// Validation Exception
class ValidationException extends AppException {
  ValidationException([String message = 'Validation error occurred']) : super(message);
}
