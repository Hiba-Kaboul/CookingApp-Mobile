import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CommunityPostCard extends StatelessWidget {
  final String userName;
  final String timeAgo;
  final String content;
  final String imagePath;
  final String hashTag;
  final int likes;
  final int comments;

  const CommunityPostCard({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.content,
    required this.imagePath,
    required this.hashTag,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الرأس: صورة المستخدم والاسم
          ListTile(
            leading: const CircleAvatar(backgroundImage: AssetImage("assets/images/chef.png")),
            title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(timeAgo),
            trailing: const Icon(Icons.star_border),
          ),
          
          // 2. الجسم: صورة الوصفة مع الهاشتاج
          Stack(
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: 250),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                  child: Text(hashTag, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          
          // 3. المحتوى والنص
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(content, textAlign: TextAlign.right),
          ),
          
          // 4. التذييل: التفاعل
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.favorite, color:AppColors.primary),
                const SizedBox(width: 5),
                Text("$likes"),
                const SizedBox(width: 20),
                Icon(Icons.chat_bubble_outline, color: Colors.grey),
                const SizedBox(width: 5),
                Text("$comments"),
                const SizedBox(width: 20),
                Icon(Icons.share, color: Colors.grey),
               
                const Spacer(),
                const Icon(Icons.bookmark_border),
              ],
            ),
            
          ),
        ],
      ),
    );
  }
}