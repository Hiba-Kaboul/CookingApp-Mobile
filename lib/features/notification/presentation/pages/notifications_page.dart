import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import '../../data/api/delete_notification_api.dart';
import '../../data/api/mark_all_notifications_read_api.dart';
import '../../data/api/notifications_api.dart';
import '../../data/fcm_service.dart';
import '../../data/models/notification_model.dart';
import '../bloc/bloc_delete_notification/delete_notification_bloc.dart';
import '../bloc/bloc_delete_notification/delete_notification_event.dart';
import '../bloc/bloc_delete_notification/delete_notification_state.dart';
import '../bloc/bloc_mark_all_notifications_read/mark_all_notifications_read_bloc.dart';
import '../bloc/bloc_mark_all_notifications_read/mark_all_notifications_read_event.dart';
import '../bloc/bloc_mark_all_notifications_read/mark_all_notifications_read_state.dart';
import '../bloc/bloc_notifications/notifications_bloc.dart';
import '../bloc/bloc_notifications/notifications_event.dart';
import '../bloc/bloc_notifications/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationsBloc(NotificationsApi())
            ..add(GetNotificationsEvent()),
        ),
        BlocProvider(
          create: (_) =>
              MarkAllNotificationsReadBloc(MarkAllNotificationsReadApi()),
        ),
        BlocProvider(
          create: (_) => DeleteNotificationBloc(DeleteNotificationApi()),
        ),
      ],
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  bool _didMarkAllRead = false;

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف الإشعار"),
        content: const Text("هل أنت متأكد أنك تريد حذف هذا الإشعار ؟؟"),
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
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsSuccess &&
                !_didMarkAllRead &&
                state.unreadCount > 0) {
              _didMarkAllRead = true;
              context
                  .read<MarkAllNotificationsReadBloc>()
                  .add(MarkAllNotificationsReadRequested());
            }
          },
        ),
        BlocListener<MarkAllNotificationsReadBloc,
            MarkAllNotificationsReadState>(
          listener: (context, state) {
            if (state is MarkAllNotificationsReadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<DeleteNotificationBloc, DeleteNotificationState>(
          listener: (context, state) {
            if (state is DeleteNotificationSuccess) {
              context.read<NotificationsBloc>().add(
                    RemoveNotificationLocallyEvent(state.notificationId),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("تم حذف الإشعار بنجاح"),
                ),
              );
            }
            if (state is DeleteNotificationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("الإشعارات", style: AppTextStyles.appBarTitle),
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationsError) {
              return Center(child: Text(state.message));
            }

            if (state is NotificationsEmpty) {
              return const Center(child: Text("لا يوجد إشعارات"));
            }

            if (state is NotificationsSuccess) {
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = state.notifications[index];
                  return _NotificationTile(
                    notification: item,
                    onTap: () {
                      FcmService.openNotificationTarget(
                        type: item.type,
                        postId: item.postId,
                        recipeId: item.recipeId,
                      );
                    },
                    onDelete: () async {
                      final confirmed = await _confirmDelete(context);
                      if (!confirmed || !context.mounted) return;
                      context
                          .read<DeleteNotificationBloc>()
                          .add(DeleteNotificationRequested(item.id));
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  IconData get _icon {
    if (notification.isLike) return Icons.favorite;
    if (notification.isComment) return Icons.chat_bubble_outline;
    if (notification.isApproved) return Icons.check_circle_outline;
    if (notification.isRejected) return Icons.cancel_outlined;
    if (notification.isShopping) return Icons.shopping_cart_outlined;
    if (notification.isRecipe) return Icons.restaurant_menu;
    return notification.isRead
        ? Icons.notifications_none
        : Icons.notifications;
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final backgroundColor =
        isUnread ? const Color(0xFFE8C4B8) : Colors.white;
    final titleStyle = AppTextStyles.title.copyWith(
      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
      color: isUnread ? AppColors.textDark : AppColors.light_brown,
    );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? AppColors.primary.withOpacity(0.25)
              : AppColors.inputBorder.withOpacity(0.6),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isUnread
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.otpCardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _icon,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title.isEmpty
                                ? 'إشعار'
                                : notification.title,
                            style: titleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (notification.body.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              notification.body,
                              style: AppTextStyles.subHeading,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (notification.createdAt.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              notification.createdAt,
                              style: AppTextStyles.hint,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
