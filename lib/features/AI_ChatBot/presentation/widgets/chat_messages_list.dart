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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFBEDE9),
            AppColors.background,
          ],
        ),
      ),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoading ||
              state is ChatLoaded ||
              state is ChatError) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state is ChatInitial) {
            return _buildEmptyState();
          }

          if (state is ChatLoading) {
            return _buildMessagesWithLoader(state.messages);
          }

          if (state is ChatError) {
            return Column(
              children: [
                Expanded(child: _buildMessagesList(state.messages)),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
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
      ),
    );
  }

 Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFFC97964)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.8),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Image.asset(
            "assets/images/chatboat.png",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "المساعد الذكي بانتظارك",
          style: AppTextStyles.names.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 6),
        Text(
          "اسألني عن أي وصفة، وأنا هون لمساعدتك",
          style: AppTextStyles.subHeading,
        ),
      ],
    ),
  );
}

  Widget _buildMessagesList(List messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
      itemCount: messages.length,
      itemBuilder: (_, index) {
        final msg = messages[index];
        return ChatBubble(
          text: msg.content,
          isUser: msg.isUser,
          time: msg.time,
        );
      },
    );
  }

  Widget _buildMessagesWithLoader(List messages) {
    return Column(
      children: [
        Expanded(child: _buildMessagesList(messages)),
        Padding(
          padding: const EdgeInsets.only(bottom: 14, top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "جاري الكتابة...",
                style: AppTextStyles.subHeading.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}