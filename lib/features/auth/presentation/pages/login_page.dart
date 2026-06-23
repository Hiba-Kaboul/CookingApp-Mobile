import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/utils/token_storage.dart';
import 'package:project2/features/auth/presentation/pages/forgot_Password_Page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../main_navigation/presentation/pages/main_navigation_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
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
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            await TokenStorage.saveSession(
              token: state.token,
              name: state.name,
              email: _emailController.text.trim(),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const MainNavigationPage(),
              ),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              centerTitle: true,
              title: const Text(AppStrings.loginTitle,
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
                        imagePath: 'assets/images/Image Header_margin.png'),
                    const SizedBox(height: 24),

                    // العنوان
                    const Text(AppStrings.welcomeBack,
                        style: AppTextStyles.heading),
                    const SizedBox(height: 6),
                    const Text(AppStrings.welcomeSub,
                        style: AppTextStyles.subHeading),
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForgotPasswordPage(),
                              ));
                        },
                        child: const Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.link,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // زر تسجيل الدخول
                    state is AuthLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary),
                          )
                        : PrimaryButton(
                            text: AppStrings.loginButton,
                            onPressed: () {
                              if (_emailController.text.trim().isEmpty ||
                                  _passwordController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('فضلاً املأ كل الحقول'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                                return;
                              }
                              context.read<AuthBloc>().add(
                                    LoginSubmitted(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    ),
                                  );
                            },
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
                          const Text(AppStrings.noAccount,
                              style: AppTextStyles.subHeading),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            ),
                            child: const Text(AppStrings.registerNow,
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
        },
      ),
    );
  }
}
