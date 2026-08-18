// presentation/bloc/bloc_conversations/conversations_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/chat_conversations_api.dart';
import 'conversations_event.dart';
import 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final ConversationsApi api;

  ConversationsBloc(this.api) : super(ConversationsInitial()) {
    on<GetConversationsEvent>(_onGetConversations);
  }

  Future<void> _onGetConversations(
    GetConversationsEvent event,
    Emitter<ConversationsState> emit,
  ) async {
    emit(ConversationsLoading());

    try {
      final response = await api.getConversations();

      if (response.data.isEmpty) {
        emit(ConversationsEmpty());
      } else {
        emit(ConversationsLoaded(response.data));
      }
    } catch (e) {
      emit(ConversationsError("صار في خطأ، حاول كمان مرة"));
    }
  }
}