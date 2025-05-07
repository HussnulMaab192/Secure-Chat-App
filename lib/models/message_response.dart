class MessageResponse {
  final bool success;
  final String message;
  final MessageDetails messageDetails;

  MessageResponse({
    required this.success,
    required this.message,
    required this.messageDetails,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      messageDetails: MessageDetails.fromJson(json['messageDetails']),
    );
  }
}

class MessageDetails {
  final String message;
  final String username;
  final String timestamp;

  MessageDetails({
    required this.message,
    required this.username,
    required this.timestamp,
  });

  factory MessageDetails.fromJson(Map<String, dynamic> json) {
    return MessageDetails(
      message: json['message'] ?? '',
      username: json['username'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
