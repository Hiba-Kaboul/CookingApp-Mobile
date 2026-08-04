// presentation/widgets/chat_messages_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import '../bloc/bloc_chat_start/chat_bloc.dart';
import '../bloc/bloc_chat_start/chat_state.dart';
import 'chat_bubble.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({super.key});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    // بننتظر فريم واحد لحتى الـ ListView يخلص يبني نفسه بالمحتوى الجديد
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        // 👇 كل ما تتغير الحالة (رسالة جديدة، رد، تحميل محادثة) ننزل لتحت
        if (state is ChatLoading || state is ChatLoaded || state is ChatError) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        if (state is ChatInitial) {
          return const Center(child: Text("اسألني عن أي وصفة!"));
        }

        if (state is ChatLoading) {
          return _buildMessagesWithLoader(state.messages);
        }

        if (state is ChatError) {
          return Column(
            children: [
              Expanded(child: _buildMessagesList(state.messages)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.message,
                  style: AppTextStyles.label.copyWith(color: Colors.red),
                ),
              ),
            ],
          );
        }

        if (state is ChatLoaded) {
          return _buildMessagesList(state.messages);
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildMessagesList(List messages) {
    return ListView.builder(
      controller: _scrollController, // 👈 جديد
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (_, index) {
        final msg = messages[index];
        return ChatBubble(text: msg.content, isUser: msg.isUser);
      },
    );
  }

  Widget _buildMessagesWithLoader(List messages) {
    return Column(
      children: [
        Expanded(child: _buildMessagesList(messages)),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ],
    );
  }
}