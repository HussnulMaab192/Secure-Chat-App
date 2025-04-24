import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String username;
  final String email;
  final String password;

  SignUpParams({
    required this.username,
    required this.email,
    required this.password,
  });
}

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, User>> call(SignUpParams params) {
    return repository.signUp(
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}
