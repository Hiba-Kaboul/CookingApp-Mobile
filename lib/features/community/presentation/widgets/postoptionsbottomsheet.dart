import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// استبدل المسار التالي بمسار الـ Bloc الخاص بك
import '../bloc/bloc_delete_post/delete_users_posts_bloc.dart';
import '../bloc/bloc_delete_post/delete_users_posts_event.dart';


class PostOptionsBottomSheet extends StatelessWidget {
  final int postId;

  const PostOptionsBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // أو لون الثيم الخاص بك
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ليأخذ حجم المحتوى فقط
        children: [
          // 1. المقبض العلوي (الخط الرمادي الصغير)
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 2. خيارات القائمة
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Why you're seeing this"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text("Interested"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.highlight_off),
            title: const Text("Not interested"),
            onTap: () => Navigator.pop(context),
          ),
          
          // 3. خيار الحذف (مميز باللون الأحمر)
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text("Delete", style: TextStyle(color: Colors.red)),
            onTap: () {
              // إرسال حدث الحذف للـ Bloc
              context.read<DeleteUsersPostsBloc>().add(DeletePostsEvent(postId));
              Navigator.pop(context); // إغلاق القائمة
            },
          ),
          const SizedBox(height: 20), // مسافة إضافية في الأسفل
        ],
      ),
    );
  }
}