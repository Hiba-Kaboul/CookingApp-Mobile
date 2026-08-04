// presentation/bloc/bloc_delete_conversation/delete_conversation_state.dart
abstract class DeleteConversationState {}

class DeleteConversationInitial extends DeleteConversationState {}

class DeleteConversationLoading extends DeleteConversationState {
  final int conversationId;
  DeleteConversationLoading(this.conversationId);
}

class DeleteConversationSuccess extends DeleteConversationState {
  final int conversationId;
  DeleteConversationSuccess(this.conversationId);
}

class DeleteConversationFailure extends DeleteConversationState {
  final int conversationId;
  final String message;
  DeleteConversationFailure({
    required this.conversationId,
    required this.message,
  });
}