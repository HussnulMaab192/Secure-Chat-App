import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import '../services/shared_pref_service.dart';
import '../utils/toast_util.dart';
import '../constants/api_constants.dart';
import '../models/message_response.dart';

class ChatProvider with ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _getChatLoading = false;
  bool _postMessageLoading = false;
  bool _clearChatLoading = false;
  final _messagesController = StreamController<List<ChatMessage>>.broadcast();
  Timer? _messageTimer;

  List<ChatMessage> get messages => _messages;
  bool get getChatLoading => _getChatLoading;
  bool get postMessageLoading => _postMessageLoading;
  bool get clearChatLoading => _clearChatLoading;
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  Future<void> getMessages() async {
    try {
      _getChatLoading = true;
      notifyListeners();

      // Initial fetch
      await _fetchMessages();
      
      // Setup periodic polling
      _messageTimer?.cancel();
      _messageTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        _fetchMessages();
      });

    } catch (error) {
      _getChatLoading = false;
      notifyListeners();
      debugPrint('Get Messages Exception: $error');
      ToastUtil.showErrorToast('Error loading messages');
    }
  }

  Future<void> _fetchMessages() async {
    final token = SharedPrefService.getToken();
    if (token == null) {
      debugPrint('Get Messages Error: No token found');
      ToastUtil.showErrorToast('Please login again');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.messages),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _messages = data.map((json) => ChatMessage.fromJson(json)).toList();
        _messagesController.add(_messages);
        _getChatLoading = false;
        notifyListeners();
      } else {
        debugPrint('Get Messages Error: ${response.body}');
      }
    } catch (error) {
      debugPrint('Fetch Messages Error: $error');
    }
  }

  Future<void> postMessage(String message) async {
    try {
      _postMessageLoading = true;
      notifyListeners();

      final token = SharedPrefService.getToken();
      if (token == null) {
        debugPrint('Post Message Error: No token found');
        ToastUtil.showErrorToast('Please login again');
        return;
      }

      debugPrint('Sending message: $message');
      final response = await http.post(
        Uri.parse(ApiConstants.messages),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'message': message}),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      _postMessageLoading = false;
      notifyListeners();

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Decoded response: $responseData');
        await getMessages(); // Refresh messages after posting
        ToastUtil.showSuccessToast('Message sent successfully');
      } else {
        debugPrint('Post Message Error: ${response.body}');
        ToastUtil.showErrorToast(responseData['message'] ?? 'Failed to send message');
      }
    } catch (error) {
      _postMessageLoading = false;
      notifyListeners();
      debugPrint('Post Message Exception: $error');
      ToastUtil.showErrorToast('Error sending message');
    }
  }

  Future<void> clearChat() async {
    try {
      _clearChatLoading = true;
      notifyListeners();

      final token = SharedPrefService.getToken();
      if (token == null) {
        debugPrint('Clear Chat Error: No token found');
        ToastUtil.showErrorToast('Please login again');
        return;
      }

      final response = await http.delete(
        Uri.parse(ApiConstants.clearChat),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Clear Chat Response Status: ${response.statusCode}');
      debugPrint('Clear Chat Response Body: ${response.body}');

      _clearChatLoading = false;
      notifyListeners();

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE html>')) {
        debugPrint('Received HTML response instead of JSON');
        ToastUtil.showErrorToast('Server error occurred');
        return;
      }

      try {
        final responseData = json.decode(response.body);
        if (response.statusCode == 200 && responseData['success'] == true) {
          debugPrint('Chat cleared successfully: ${responseData['messagesDeleted']} messages');
          ToastUtil.showSuccessToast('${responseData['messagesDeleted']} messages cleared');
          _messages.clear();
          _messagesController.add(_messages);
          notifyListeners();
        } else {
          debugPrint('Clear Chat Error: ${response.body}');
          ToastUtil.showErrorToast(responseData['message'] ?? 'Failed to clear chat');
        }
      } catch (e) {
        debugPrint('JSON Parse Error: $e');
        ToastUtil.showErrorToast('Invalid response from server');
      }
    } catch (error) {
      _clearChatLoading = false;
      notifyListeners();
      debugPrint('Clear Chat Exception: $error');
      ToastUtil.showErrorToast('Error clearing chat');
    }
  }

  void cleanupOnSignOut() {
    _messageTimer?.cancel();
    _messages.clear();
    _messagesController.add(_messages);
    _getChatLoading = false;
    _postMessageLoading = false;
    _clearChatLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _messagesController.close();
    super.dispose();
  }
}
