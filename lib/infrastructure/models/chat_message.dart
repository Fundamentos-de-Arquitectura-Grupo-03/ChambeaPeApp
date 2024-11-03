class ChatMessage {
  final String content;
  final String type;
  final String user;
  final String timestamp;

  ChatMessage({
    required this.content,
    required this.type,
    required this.user,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'],
      type: json['type'],
      user: json['user'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'type': type,
      'user': user,
    };
  }
}
