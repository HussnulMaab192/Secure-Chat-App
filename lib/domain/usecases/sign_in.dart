import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Either<Failure, String>> call(SignInParams params) {
    return repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
