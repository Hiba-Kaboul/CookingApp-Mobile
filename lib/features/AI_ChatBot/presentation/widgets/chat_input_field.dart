// presentation/widgets/chat_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import '../bloc/bloc_chat_start/chat_bloc.dart';
import '../bloc/bloc_chat_start/chat_event.dart';
import '../bloc/bloc_chat_start/chat_state.dart';
import '../bloc/bloc_voice_to_text/voice_to_text_bloc.dart';
import '../bloc/bloc_voice_to_text/voice_to_text_event.dart';
import '../bloc/bloc_voice_to_text/voice_to_text_state.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final bloc = context.read<ChatBloc>();
    final state = bloc.state;

    int? currentConversationId;
    if (state is ChatLoaded) currentConversationId = state.conversationId;
    if (state is ChatLoading) currentConversationId = state.conversationId;
    if (state is ChatError) currentConversationId = state.conversationId;

    if (currentConversationId == null) {
      bloc.add(ChatStartConversation(text));
    } else {
      bloc.add(ChatSendMessage(text));
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoiceToTextBloc, VoiceToTextState>(
      listener: (context, state) {
        if (state is VoiceTranscribed) {
          // 👇 النص بينحط بالـ TextField، ما بينبعت لحاله
          setState(() {
            _controller.text = state.text;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });
        }

        if (state is VoiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                style: AppTextStyles.label,
                decoration: InputDecoration(
                  hintText: "اكتب سؤالك هنا...",
                  filled: true,
                  fillColor: AppColors.buttonText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _send(context),
              ),
            ),
            const SizedBox(width: 4),
            // 👇 زر المايك
            BlocBuilder<VoiceToTextBloc, VoiceToTextState>(
              builder: (context, state) {
                final isRecording = state is VoiceRecording;
                final isProcessing = state is VoiceProcessing;

                if (isProcessing) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                return IconButton(
                  icon: Icon(
                    isRecording ? Icons.stop_circle : Icons.mic,
                    color: isRecording ? Colors.red : AppColors.primary,
                  ),
                  onPressed: () {
                    final voiceBloc = context.read<VoiceToTextBloc>();
                    if (isRecording) {
                      voiceBloc.add(VoiceRecordingStopped());
                    } else {
                      voiceBloc.add(VoiceRecordingStarted());
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: () => _send(context),
            ),
          ],
        ),
      ),
    );
  }
}