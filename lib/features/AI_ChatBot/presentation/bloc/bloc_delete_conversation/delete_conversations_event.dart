// presentation/bloc/bloc_delete_conversation/delete_conversation_event.dart
abstract class DeleteConversationEvent {}

class DeleteConversationRequested extends DeleteConversationEvent {
  final int conversationId;
  DeleteConversationRequested(this.conversationId);
}