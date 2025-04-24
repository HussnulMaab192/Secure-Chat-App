import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    super.id,
    required super.message,
    required super.username,
    required super.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      username: json['username'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'username': username,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      message: message.message,
      username: message.username,
      timestamp: message.timestamp,
    );
  }
}
