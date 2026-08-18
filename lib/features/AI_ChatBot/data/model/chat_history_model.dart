// data/model/chat_history_model.dart
class ChatHistoryResponse {
  final List<ChatHistoryMessage> data;

  ChatHistoryResponse({required this.data});

  factory ChatHistoryResponse.fromMap(Map<String, dynamic> map) {
    return ChatHistoryResponse(
      data: List<ChatHistoryMessage>.from(
        (map['data'] as List).map((e) => ChatHistoryMessage.fromMap(e)),
      ),
    );
  }
}

class ChatHistoryMessage {
  final int id;
  final String role; // "user" أو "assistant"
  final String content;
  final String createdAt;

  ChatHistoryMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatHistoryMessage.fromMap(Map<String, dynamic> map) {
    return ChatHistoryMessage(
      id: map['id'] ?? 0,
      role: map['role'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  bool get isUser => role == 'user';
}