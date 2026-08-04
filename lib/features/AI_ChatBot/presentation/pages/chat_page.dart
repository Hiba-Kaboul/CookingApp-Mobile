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
          // 👈 جديد
          create: (_) => VoiceToTextBloc(VoiceToTextApi()),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            title:
                const Text(" شات بوت", style: AppTextStyles.appBarTitle),
            // leading: Builder(
            //   builder: (context) => IconButton(
            //     icon: const Icon(Icons.menu, color: Colors.white),
            //     onPressed: () => Scaffold.of(context).openEndDrawer(),
            //   ),
            // ),
          ),
          endDrawer: const ChatDrawer(),
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
