import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/post_message.dart';

enum MessageStatus { initial, loading, loaded, error }

class MessageProvider with ChangeNotifier {
  final GetMessages _getMessages;
  final PostMessage _postMessage;

  MessageStatus _status = MessageStatus.initial;
  List<Message> _messages = [];
  String _errorMessage = '';
  bool _isPosting = false;

  MessageProvider({
    required GetMessages getMessages,
    required PostMessage postMessage,
  })  : _getMessages = getMessages,
        _postMessage = postMessage;

  // Getters
  MessageStatus get status => _status;
  List<Message> get messages => _messages;
  String get errorMessage => _errorMessage;
  bool get isPosting => _isPosting;

  // Get messages
  Future<void> getMessages() async {
    _status = MessageStatus.loading;
    notifyListeners();

    final result = await _getMessages();

    result.fold(
      (failure) {
        _status = MessageStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (messages) {
        _status = MessageStatus.loaded;
        _messages = messages;
        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  // Post message
  Future<void> postMessage(String message) async {
    _isPosting = true;
    notifyListeners();

    final params = PostMessageParams(message: message);
    final result = await _postMessage(params);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isPosting = false;
        notifyListeners();
      },
      (message) {
        _messages.add(message);
        _isPosting = false;
        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  // Reset error
  void resetError() {
    _errorMessage = '';
    notifyListeners();
  }
}
