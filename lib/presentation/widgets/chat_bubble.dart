import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../utils/date_formatter.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe 
                ? Theme.of(context).primaryColor 
                : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(isMe ? 12 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 12),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.start,
            children: [
              
                Text(
                  message.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white : Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              Text(
                message.message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormatter.formatTimestamp(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: isMe 
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
