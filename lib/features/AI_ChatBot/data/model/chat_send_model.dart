// data/model/chat_send_model.dart
class ChatSendResponse {
  final int status;
  final String message;
  final String reply;

  ChatSendResponse({
    required this.status,
    required this.message,
    required this.reply,
  });

  factory ChatSendResponse.fromMap(Map<String, dynamic> map) {
    return ChatSendResponse(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
      reply: map['data']?['reply'] ?? '',
    );
  }
}