import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/auth/presentation/pages/otp_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
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
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فضلاً عبّي كل الحقول'),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة المرور غير متطابقة'),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          RegisterSubmitted(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            passwordConfirmation: _confirmPasswordController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OtpPage(email: state.email),
              ),
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
              title: const Text(AppStrings.registerTitle,
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
                    const Text(AppStrings.createAccount,
                        style: AppTextStyles.heading),
                    const SizedBox(height: 6),
                    const Text(AppStrings.createAccountSub,
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
                    const SizedBox(height: 16),

                    // حقل تأكيد كلمة المرور
                    CustomTextField(
                      label: AppStrings.confirmpassword,
                      hint: '••••••••',
                      suffixIcon: Icons.lock_outline,
                      controller: _confirmPasswordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),

                    // زر إنشاء الحساب
                    state is AuthLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary),
                          )
                        : PrimaryButton(
                            text: AppStrings.registerButton,
                            onPressed: () => _handleRegister(context),
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
                          const Text(AppStrings.hasAccount,
                              style: AppTextStyles.subHeading),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            ),
                            child: const Text(AppStrings.loginNow,
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
