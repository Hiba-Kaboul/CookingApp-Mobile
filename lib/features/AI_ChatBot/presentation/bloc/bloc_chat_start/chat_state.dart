// presentation/bloc/bloc_chat/chat_state.dart
import 'chat_message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final List<ChatMessage> messages;
  final int? conversationId;

  ChatLoading({required this.messages, this.conversationId});
}

class ChatError extends ChatState {
  final String message;
  final List<ChatMessage> messages;
  final int? conversationId;

  ChatError({
    required this.message,
    required this.messages,
    this.conversationId,
  });
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final int conversationId;

  ChatLoaded({
    required this.messages,
    required this.conversationId,
  });
}