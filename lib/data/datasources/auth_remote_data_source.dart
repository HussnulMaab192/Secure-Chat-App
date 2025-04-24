import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign up a new user
  ///
  /// Throws [ServerException] for all server errors
  /// Throws [NetworkException] for network-related errors
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
  });

  /// Sign in an existing user
  ///
  /// Throws [ServerException] for all server errors
  /// Throws [NetworkException] for network-related errors
  /// Throws [AuthException] for authentication errors
  Future<String> signIn({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        ApiConstants.signUp,
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      return UserModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        ApiConstants.signIn,
        body: {
          'email': email,
          'password': password,
        },
      );

      return response['token'];
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
