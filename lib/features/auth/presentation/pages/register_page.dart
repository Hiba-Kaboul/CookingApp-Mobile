import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/auth_header_image.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_buttons_row.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
        title: Text(AppStrings.registerTitle,
            style: AppTextStyles.appBarTitle),
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
              const AuthHeaderImage(
                  imagePath: 'assets/images/Space for Branding.png'),
              const SizedBox(height: 24),

              // العنوان
              Text(AppStrings.createAccount, style: AppTextStyles.heading),
              const SizedBox(height: 6),
              Text(AppStrings.createAccountSub,
                  style: AppTextStyles.subHeading),
              const SizedBox(height: 24),

              // حقل الاسم
              CustomTextField(
                label: AppStrings.fullName,
                hint: AppStrings.fullNameHint,
                suffixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),

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
              const SizedBox(height: 24),

              // زر إنشاء الحساب
              PrimaryButton(
                text: AppStrings.registerButton,
                onPressed: () {},
              ),
              const SizedBox(height: 24),

              // أزرار السوشيال
              const SocialButtonsRow(),
              const SizedBox(height: 24),

              // رابط تسجيل الدخول
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.hasAccount,
                        style: AppTextStyles.subHeading),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      ),
                      child: Text(AppStrings.loginNow,
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