import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/auth_header_image.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_buttons_row.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(AppStrings.loginTitle, style: AppTextStyles.appBarTitle),
        leading: const Icon(Icons.search, color: AppColors.buttonText),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.menu, color: AppColors.buttonText),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeaderImage(imagePath: 'assets/images/Image Header_margin.png'),
              const SizedBox(height: 24),

              // العنوان
              Text(AppStrings.welcomeBack, style: AppTextStyles.heading),
              const SizedBox(height: 6),
              Text(AppStrings.welcomeSub, style: AppTextStyles.subHeading),
              const SizedBox(height: 24),

              // حقل الإيميل
              CustomTextField(
                label: AppStrings.email,
                hint: AppStrings.emailHint,
                suffixIcon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 16),

              // حقل كلمة المرور
              CustomTextField(
                label: AppStrings.password,
                hint: '••••••••',
                suffixIcon: Icons.lock_outline,
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 8),

              // نسيت كلمة المرور
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    AppStrings.forgotPassword,
                    style: AppTextStyles.link,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // زر تسجيل الدخول
              PrimaryButton(
                text: AppStrings.loginButton,
                onPressed: () {},
              ),
              const SizedBox(height: 24),

              // أزرار السوشيال
              const SocialButtonsRow(),
              const SizedBox(height: 24),

              // رابط إنشاء حساب
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.noAccount,
                        style: AppTextStyles.subHeading),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterPage(),
                        ),
                      ),
                      child: Text(AppStrings.registerNow,
                          style: AppTextStyles.link),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}