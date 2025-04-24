import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/message_model.dart';

abstract class MessageRemoteDataSource {
  /// Get all messages
  ///
  /// Throws [ServerException] for all server errors
  /// Throws [NetworkException] for network-related errors
  /// Throws [AuthException] for authentication errors
  Future<List<MessageModel>> getMessages();

  /// Post a new message
  ///
  /// Throws [ServerException] for all server errors
  /// Throws [NetworkException] for network-related errors
  /// Throws [AuthException] for authentication errors
  Future<MessageModel> postMessage(String message);
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final ApiClient client;

  MessageRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MessageModel>> getMessages() async {
    try {
      final response = await client.get(ApiConstants.messages);
      
      return (response as List)
          .map((message) => MessageModel.fromJson(message))
          .toList();
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

  @override
  Future<MessageModel> postMessage(String message) async {
    try {
      final response = await client.post(
        ApiConstants.messages,
        body: {'message': message},
      );
      
      return MessageModel.fromJson(response);
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
