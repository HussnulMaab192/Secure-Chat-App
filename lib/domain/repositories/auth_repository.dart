import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Sign up a new user
  /// 
  /// Returns [Right(User)] on success, [Left(Failure)] on error
  Future<Either<Failure, User>> signUp({
    required String username,
    required String email,
    required String password,
  });
  
  /// Sign in an existing user
  /// 
  /// Returns [Right(String)] with token on success, [Left(Failure)] on error
  Future<Either<Failure, String>> signIn({
    required String email,
    required String password,
  });
  
  /// Check if user is logged in
  /// 
  /// Returns [bool] indicating login status
  Future<bool> isLoggedIn();
  
  /// Get current user data
  /// 
  /// Returns [Right(User)] on success, [Left(Failure)] on error
  Future<Either<Failure, User?>> getCurrentUser();
  
  /// Sign out the current user
  /// 
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> signOut();
}
