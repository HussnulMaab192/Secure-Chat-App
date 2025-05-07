import 'dart:async';
import 'package:chat_app_secure_programming/services/shared_pref_service.dart';
import 'package:chat_app_secure_programming/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import 'login_screen.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  String currentUsername = '';
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });
  }

  Future<void> _loadUserData() async {
    final userData = await SharedPrefService.getUserData();
    setState(() {
      currentUsername = userData['username'] ?? '';
      _userRole = userData['role'] ?? '';
    });
    debugPrint('Current user role: $_userRole'); // Debug print
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty){
      ToastUtil.showErrorToast('Message cannot be empty');
      return;
    }
    
    final message = _messageController.text.trim();
    _messageController.clear();

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.postMessage(message);
    
    if (mounted) {
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    print(SharedPrefService.roleKey);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Global Chat"),
        actions: [
          if (_userRole == 'admin') // Use state variable instead of direct access
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => chatProvider.clearChat(),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.getChatLoading
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder(
                    stream: chatProvider.messagesStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data ?? [];
                      
                      if (messages.isEmpty) {
                        return const Center(
                          child: Text('No messages yet. Start chatting!'),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.username == currentUsername;
                          
                          return ChatBubble(
                            message: message,
                            isMe: isMe,
                          );
                        },
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: chatProvider.postMessageLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  onPressed: chatProvider.postMessageLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
