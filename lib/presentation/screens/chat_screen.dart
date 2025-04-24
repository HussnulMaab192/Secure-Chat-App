import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/input_validator.dart';
import '../providers/auth_provider.dart';
import '../providers/message_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/message_bubble.dart';
import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    // Delay loading messages until after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMessages();
    });

    // Set up periodic refresh
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _refreshMessages(),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (!mounted) return;

    // Capture the context before the async gap
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);

    await messageProvider.getMessages();

    // Delay scrolling to bottom until after the build is complete
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  Future<void> _refreshMessages() async {
    // Only refresh if the widget is still mounted
    if (!mounted) return;

    // Capture the context before the async gap
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);

    // Use a microtask to avoid calling setState during build
    Future.microtask(() async {
      if (mounted) {
        await messageProvider.getMessages();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    if (!mounted) return;

    // Capture the message text before clearing the controller
    final messageText = _messageController.text.trim();
    _messageController.clear();

    // Capture the context before the async gap
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);

    await messageProvider.postMessage(messageText);

    // Delay scrolling to bottom until after the build is complete
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  Future<void> _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  Future<void> _refreshChat() async {
    if (!mounted) return;

    // Capture the context before the async gap
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);

    await messageProvider.getMessages();
    return;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final messageProvider = Provider.of<MessageProvider>(context);
    final currentUser = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.exit_to_app),
        //     onPressed: _signOut,
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messageProvider.status == MessageStatus.loading
                ? const Center(child: LoadingIndicator())
                : messageProvider.messages.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet. Start the conversation!',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshChat,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messageProvider.messages.length,
                          itemBuilder: (context, index) {
                            final message = messageProvider.messages[index];
                            final isMe = message.username == currentUser?.username;

                            return MessageBubble(
                              message: message,
                              isMe: isMe,
                            );
                          },
                        ),
                      ),
          ),

          // Error message
          if (messageProvider.errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Theme.of(context).colorScheme.error.withAlpha(25),
              child: Text(
                messageProvider.errorMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Message input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),

                const SizedBox(width: 8),

                // Send button
                Material(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: messageProvider.isPosting ? null : _sendMessage,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: messageProvider.isPosting
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : Icon(
                              Icons.send,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
