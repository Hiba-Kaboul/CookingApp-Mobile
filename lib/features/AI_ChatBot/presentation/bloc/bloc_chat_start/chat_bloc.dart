// presentation/bloc/bloc_chat_start/chat_bloc.dart
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/chat_start_api.dart';
import '../../../data/api/chat_send_api.dart';
import '../../../data/api/chat_history_api.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'chat_message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatStartApi startApi;
  final ChatSendApi sendApi;
  final ChatHistoryApi historyApi;

  int? _conversationId;
  final List<ChatMessage> _messages = [];

  ChatBloc({
    required this.startApi,
    required this.sendApi,
    required this.historyApi,
  }) : super(ChatInitial()) {
    on<ChatStartConversation>(_onStart);
    on<ChatSendMessage>(_onSend);
    on<ChatLoadConversation>(_onLoadConversation);
    on<ChatResetConversation>(_onReset);
  }

  // 👇 حدث منفصل تماماً لأول رسالة
  Future<void> _onStart(
    ChatStartConversation event,
    Emitter<ChatState> emit,
  ) async {
    _messages.add(ChatMessage(content: event.message, isUser: true));

    emit(ChatLoading(
      messages: List.from(_messages),
      conversationId: null,
    ));

    try {
      final response = await startApi.startConversation(event.message);
      _conversationId = response.data.conversationId;

      _messages.add(ChatMessage(content: response.data.reply, isUser: false));

      emit(ChatLoaded(
        messages: List.from(_messages),
        conversationId: _conversationId!,
      ));
    } catch (e) {
        if (e is DioException) {
    print("STATUS CODE: ${e.response?.statusCode}");
    print("RESPONSE DATA: ${e.response?.data}");
    print("REQUEST DATA SENT: ${e.requestOptions.data}");
    print("REQUEST URL: ${e.requestOptions.uri}");
  } else {
    print("UNKNOWN ERROR: $e");
  }
      emit(ChatError(
        
        message: "صار في خطأ ببدء المحادثة، حاول كمان مرة",
        messages: List.from(_messages),
        conversationId: null,
      ));
    }
  }

  // 👇 حدث منفصل تماماً لإكمال محادثة
  Future<void> _onSend(
    ChatSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (_conversationId == null) return; // احتياط: ما لازم يصير أصلاً

    _messages.add(ChatMessage(content: event.message, isUser: true));

    emit(ChatLoading(
      messages: List.from(_messages),
      conversationId: _conversationId,
    ));

    try {
      final response = await sendApi.sendMessage(
        conversationId: _conversationId!,
        message: event.message,
      );

      _messages.add(ChatMessage(content: response.reply, isUser: false));

      emit(ChatLoaded(
        messages: List.from(_messages),
        conversationId: _conversationId!,
      ));
    } catch (e) {
         if (e is DioException) {
    print("STATUS CODE: ${e.response?.statusCode}");
    print("RESPONSE DATA: ${e.response?.data}");
    print("REQUEST DATA SENT: ${e.requestOptions.data}");
    print("REQUEST URL: ${e.requestOptions.uri}");
  } else {
    print("UNKNOWN ERROR: $e");
  }
      emit(ChatError(
        message: "صار في خطأ بإرسال الرسالة، حاول كمان مرة",
        messages: List.from(_messages),
        conversationId: _conversationId,
      ));
    }
  }

  Future<void> _onLoadConversation(
    ChatLoadConversation event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading(messages: [], conversationId: event.conversationId));

    try {
      final response = await historyApi.getHistory(event.conversationId);

      _messages
        ..clear()
        ..addAll(
          response.data.map(
            (m) => ChatMessage(content: m.content, isUser: m.isUser),
          ),
        );

      _conversationId = event.conversationId;

      emit(ChatLoaded(
        messages: List.from(_messages),
        conversationId: _conversationId!,
      ));
    } catch (e) {
      emit(ChatError(
        message: "تعذر تحميل المحادثة",
        messages: [],
        conversationId: event.conversationId,
      ));
    }
  }

  void _onReset(ChatResetConversation event, Emitter<ChatState> emit) {
    _messages.clear();
    _conversationId = null;
    emit(ChatInitial());
  }
}