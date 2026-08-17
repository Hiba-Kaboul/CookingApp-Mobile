// presentation/pages/chat_welcome_page.dart
import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'chat_page.dart';

class ChatWelcomePage extends StatelessWidget {
  const ChatWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 👇 دائرة متوهجة خلف الصورة
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.18),
                            AppColors.primary.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 190,
                      height: 190,
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
                            blurRadius: 30,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(28),
                      child: Image.asset(
                        "assets/images/robot.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    // نجيمات صغيرة زخرفية حوالين الدائرة
                    const Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(Icons.auto_awesome,
                          color: AppColors.primary, size: 20),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      child: Icon(Icons.auto_awesome,
                          color: AppColors.primary.withOpacity(0.6), size: 14),
                    ),
                  ],
                ),

                const Spacer(flex: 2),

                Text(
                  "تعرّف على المساعد الذكي!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.names.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "اسأل عن أي وصفة واحصل على إجابة فورية\nمن مساعدنا الذكي المتخصص بالطبخ",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),

                const Spacer(flex: 3),

                // زر البدء
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChatPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ابدأ الآن",
                          style: AppTextStyles.appBarTitle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
