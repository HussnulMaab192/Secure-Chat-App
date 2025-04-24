class Message {
  final String? id;
  final String message;
  final String username;
  final DateTime timestamp;
  
  Message({
    this.id,
    required this.message,
    required this.username,
    required this.timestamp,
  });
}
