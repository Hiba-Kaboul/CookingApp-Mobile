// data/model/chat_start_model.dart
class ChatStartResponse {
  final int status;
  final String message;
  final ChatStartData data;

  ChatStartResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ChatStartResponse.fromMap(Map<String, dynamic> map) {
    return ChatStartResponse(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
      data: ChatStartData.fromMap(map['data']),
    );
  }
}

class ChatStartData {
  final int conversationId;
  final String reply;

  ChatStartData({
    required this.conversationId,
    required this.reply,
  });

  factory ChatStartData.fromMap(Map<String, dynamic> map) {
    return ChatStartData(
      conversationId: map['conversation_id'] ?? 0,
      reply: map['reply'] ?? '',
    );
  }
}