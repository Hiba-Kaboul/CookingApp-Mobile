// data/model/conversation_model.dart
class ConversationsResponse {
  final List<Conversation> data;

  ConversationsResponse({required this.data});

  factory ConversationsResponse.fromMap(Map<String, dynamic> map) {
    return ConversationsResponse(
      data: List<Conversation>.from(
        (map['data'] as List).map((e) => Conversation.fromMap(e)),
      ),
    );
  }
}

class Conversation {
  final int id;
  final String title;
  final int messagesCount;
  final String createdAt;

  Conversation({
    required this.id,
    required this.title,
    required this.messagesCount,
    required this.createdAt,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      messagesCount: map['messages_count'] ?? 0,
      createdAt: map['created_at'] ?? '',
    );
  }
}