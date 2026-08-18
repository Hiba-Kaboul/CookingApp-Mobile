// presentation/bloc/bloc_chat_start/chat_event.dart
abstract class ChatEvent {}

// أول رسالة بمحادثة جديدة
class ChatStartConversation extends ChatEvent {
  final String message;
  ChatStartConversation(this.message);
}

// إكمال محادثة موجودة
class ChatSendMessage extends ChatEvent {
  final String message;
  ChatSendMessage(this.message);
}

// تحميل محادثة قديمة من الـ history
class ChatLoadConversation extends ChatEvent {
  final int conversationId;
  ChatLoadConversation(this.conversationId);
}

// بدء محادثة جديدة (تصفير الحالة)
class ChatResetConversation extends ChatEvent {}