class ChatMessage {
  final String message;
  final String timestamp;
  final String username;

  ChatMessage({
    required this.message,
    required this.timestamp,
    required this.username,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
