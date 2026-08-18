// presentation/widgets/chat_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import '../../data/api/delete_conversation_api.dart';
import '../bloc/bloc_chat_start/chat_bloc.dart';
import '../bloc/bloc_chat_start/chat_event.dart';
import '../bloc/bloc_conversations/conversations_bloc.dart';
import '../bloc/bloc_conversations/conversations_event.dart';
import '../bloc/bloc_conversations/conversations_state.dart';
import '../bloc/bloc_delete_conversation/delete_conversation_bloc.dart';
import '../bloc/bloc_delete_conversation/delete_conversation_state.dart';
import '../bloc/bloc_delete_conversation/delete_conversations_event.dart';
import 'conversation_tile.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف المحادثة"),
        content: const Text("هل أنت متأكد إنك بدك تحذف هاي المحادثة؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeleteConversationBloc(DeleteConversationApi()),
      child: BlocListener<DeleteConversationBloc, DeleteConversationState>(
        listener: (context, state) {
          if (state is DeleteConversationSuccess) {
            context.read<ConversationsBloc>().add(GetConversationsEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(" تم حذف المحادثة ب نجاح")),
            );
          }

          if (state is DeleteConversationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Drawer(
          backgroundColor: AppColors.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              _DrawerHeader(
                onClose: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.add, color: AppColors.primary),
                title: const Text("محادثة جديدة", style: AppTextStyles.names),
                onTap: () {
                  context.read<ChatBloc>().add(ChatResetConversation());
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              Expanded(
                child: BlocBuilder<ConversationsBloc, ConversationsState>(
                  builder: (context, state) {
                    if (state is ConversationsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2.5,
                        ),
                      );
                    }

                    if (state is ConversationsLoaded) {
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: state.conversations.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, index) {
                          final convo = state.conversations[index];
                          return ConversationTile(
                            conversation: convo,
                            onTap: () {
                              context
                                  .read<ChatBloc>()
                                  .add(ChatLoadConversation(convo.id));
                              Navigator.pop(context);
                            },
                            onDelete: () async {
                              final confirmed = await _confirmDelete(context);
                              if (confirmed) {
                                context.read<DeleteConversationBloc>().add(
                                      DeleteConversationRequested(convo.id),
                                    );
                              }
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _DrawerHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary,
            Color(0xFFC97964),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'المحادثات السابقة',
            style: AppTextStyles.appBarTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            'تصفح محادثاتك مع المساعد الذكي',
            style: AppTextStyles.subHeading.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}