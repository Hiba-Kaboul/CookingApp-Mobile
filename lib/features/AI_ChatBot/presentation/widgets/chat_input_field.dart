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
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

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
          setState(() {
            _controller.text = state.text;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });
        }

        if (state is VoiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          12, 10, 12, MediaQuery.of(context).padding.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: AppColors.inputBorder.withOpacity(0.6),
                  ),
                ),
                child: Row(
                  children: [
                    // زر المايك جوا الحقل
                    BlocBuilder<VoiceToTextBloc, VoiceToTextState>(
                      builder: (context, state) {
                        final isRecording = state is VoiceRecording;
                        final isProcessing = state is VoiceProcessing;

                        if (isProcessing) {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        return IconButton(
                          splashRadius: 22,
                          icon: Icon(
                            isRecording
                                ? Icons.stop_circle_rounded
                                : Icons.mic_none_rounded,
                            color: isRecording
                                ? Colors.red
                                : AppColors.light_brown,
                            size: 24,
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
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.right,
                        minLines: 1,
                        maxLines: 4,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: "اكتب سؤالك هنا...",
                          hintStyle: AppTextStyles.label.copyWith(
                            color: AppColors.hintText,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: (_) => _send(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // زر الإرسال الدائري
            GestureDetector(
              onTap: () => _send(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _hasText
                        ? [AppColors.primary, const Color(0xFFC9573F)]
                        : [
                            AppColors.hintText.withOpacity(0.5),
                            AppColors.hintText.withOpacity(0.5),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: _hasText
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}