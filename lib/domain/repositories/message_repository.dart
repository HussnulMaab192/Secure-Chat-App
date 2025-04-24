import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/message.dart';

abstract class MessageRepository {
  /// Get all messages
  /// 
  /// Returns [Right(List<Message>)] on success, [Left(Failure)] on error
  Future<Either<Failure, List<Message>>> getMessages();
  
  /// Post a new message
  /// 
  /// Returns [Right(Message)] on success, [Left(Failure)] on error
  Future<Either<Failure, Message>> postMessage(String message);
}
