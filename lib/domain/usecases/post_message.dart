import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/message.dart';
import '../repositories/message_repository.dart';

class PostMessageParams {
  final String message;

  PostMessageParams({required this.message});
}

class PostMessage {
  final MessageRepository repository;

  PostMessage(this.repository);

  Future<Either<Failure, Message>> call(PostMessageParams params) {
    return repository.postMessage(params.message);
  }
}
