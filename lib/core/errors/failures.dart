// Base Failure
abstract class Failure {
  final String message;
  
  Failure(this.message);
  
  @override
  String toString() => message;
}

// Server Failure
class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error occurred']) : super(message);
}

// Network Failure
class NetworkFailure extends Failure {
  NetworkFailure([String message = 'Network error occurred']) : super(message);
}

// Authentication Failure
class AuthFailure extends Failure {
  AuthFailure([String message = 'Authentication error occurred']) : super(message);
}

// Cache Failure
class CacheFailure extends Failure {
  CacheFailure([String message = 'Cache error occurred']) : super(message);
}

// Validation Failure
class ValidationFailure extends Failure {
  ValidationFailure([String message = 'Validation error occurred']) : super(message);
}
