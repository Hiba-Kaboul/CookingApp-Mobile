// presentation/bloc/bloc_conversations/conversations_state.dart

import '../../../data/model/chat_conversation_model.dart';

abstract class ConversationsState {}

class ConversationsInitial extends ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsError extends ConversationsState {
  final String message;
  ConversationsError(this.message);
}

class ConversationsEmpty extends ConversationsState {}

class ConversationsLoaded extends ConversationsState {
  final List<Conversation> conversations;
  ConversationsLoaded(this.conversations);
}