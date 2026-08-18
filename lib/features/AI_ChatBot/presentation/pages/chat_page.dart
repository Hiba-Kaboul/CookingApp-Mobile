// presentation/pages/chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import '../../data/api/chat_conversations_api.dart';
import '../../data/api/chat_history_api.dart';
import '../../data/api/chat_start_api.dart';
import '../../data/api/chat_send_api.dart';
import '../../data/api/voice_to_text_api.dart';
import '../bloc/bloc_chat_start/chat_bloc.dart';
import '../bloc/bloc_conversations/conversations_bloc.dart';
import '../bloc/bloc_conversations/conversations_event.dart';
import '../bloc/bloc_voice_to_text/voice_to_text_bloc.dart';
import '../widgets/chat_messages_list.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/chat_drawer.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatBloc(
            startApi: ChatStartApi(),
            sendApi: ChatSendApi(),
            historyApi: ChatHistoryApi(),
          ),
        ),
        BlocProvider(
          create: (_) => ConversationsBloc(ConversationsApi())
            ..add(GetConversationsEvent()),
        ),
        BlocProvider(
          create: (_) => VoiceToTextBloc(VoiceToTextApi()),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          endDrawer: const ChatDrawer(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.primary, Color(0xFFC97964)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      // 👇 زر الرجوع للشاشة الرئيسية
                      IconButton(
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20),
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.18),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.4)),
                        ),
                        child: Image.asset(
                          "assets/images/chatboat.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "المساعد الذكي",
                              style: AppTextStyles.appBarTitle.copyWith(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // زر القائمة (الدرور) — رجعناه هون بالنهاية
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu_rounded,
                              color: Colors.white),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: const Column(
            children: [
              Expanded(child: ChatMessagesList()),
              ChatInputField(),
            ],
          ),
        ),
      ),
    );
  }
}
