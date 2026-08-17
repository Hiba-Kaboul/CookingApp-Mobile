// presentation/widgets/chat_bubble.dart
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime? time;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    // final timeText = time != null ? DateFormat('h:mm a').format(time!) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _BotAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.primary,
                          Color(0xFFC9573F),
                        ],
                      )
                    : null,
                color: isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isUser ? AppColors.primary : Colors.black)
                        .withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: isUser
                    ? null
                    : Border.all(
                        color: AppColors.inputBorder.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.label.copyWith(
                      color: isUser ? Colors.white : AppColors.textDark,
                      height: 1.5,
                    ),
                  ),
                  // if (timeText.isNotEmpty) ...[
                  //   const SizedBox(height: 4),
                  //   Text(
                  //     timeText,
                  //     style: TextStyle(
                  //       fontSize: 10.5,
                  //       color: isUser
                  //           ? Colors.white.withOpacity(0.75)
                  //           : AppColors.hintText,
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFFC97964)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(
        "assets/images/chatboat.png",
        fit: BoxFit.contain,
      ),
    );
  }
}