// presentation/bloc/bloc_chat/chat_message.dart
// presentation/bloc/bloc_chat_start/chat_message.dart
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}