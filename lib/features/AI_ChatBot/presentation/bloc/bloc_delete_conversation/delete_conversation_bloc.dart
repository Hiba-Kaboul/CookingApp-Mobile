// presentation/bloc/bloc_delete_conversation/delete_conversation_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/delete_conversation_api.dart';
import 'delete_conversations_event.dart';
import 'delete_conversation_state.dart';

class DeleteConversationBloc
    extends Bloc<DeleteConversationEvent, DeleteConversationState> {
  final DeleteConversationApi api;

  DeleteConversationBloc(this.api) : super(DeleteConversationInitial()) {
    on<DeleteConversationRequested>(_onDelete);
  }

  Future<void> _onDelete(
    DeleteConversationRequested event,
    Emitter<DeleteConversationState> emit,
  ) async {
    emit(DeleteConversationLoading(event.conversationId));

    try {
      await api.deleteConversation(event.conversationId);
      emit(DeleteConversationSuccess(event.conversationId));
    } catch (e) {
      emit(DeleteConversationFailure(
        conversationId: event.conversationId,
        message: "تعذر حذف المحادثة",
      ));
    }
  }
}