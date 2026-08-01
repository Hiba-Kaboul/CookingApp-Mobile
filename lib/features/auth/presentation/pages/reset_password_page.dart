import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_strings.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'package:project2/features/auth/presentation/pages/otp_page_forget.dart';
import 'package:project2/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:project2/features/auth/presentation/widgets/primary_button.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newPassword = TextEditingController();
  final _confirmNewPassword = TextEditingController();

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmNewPassword.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_newPassword.text.trim().isEmpty ||
        _confirmNewPassword.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
      );
      return;
    }

    if (_newPassword.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة المرور يجب أن تكون 8 أحرف على الأقل'),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    if (_newPassword.text.trim() != _confirmNewPassword.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة المرور غير متطابقة'),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpPageForget(
          email: widget.email,
          password: _newPassword.text.trim(),
          passwordConfirmation: _confirmNewPassword.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ResetPasswordTextField,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          AppStrings.resetTitle,
          style: AppTextStyles.appBarChangepassword,
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.buttonText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Image.asset(
                'assets/images/1782168548270.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 400,
              child: CustomTextField(
                label: '',
                hint: AppStrings.newPassword,
                suffixIcon: Icons.lock_outline,
                controller: _newPassword,
                backgroundColor: AppColors.ResetPasswordBackgroundTextField,
                isPassword: true,
                hintStyle: AppTextStyles.confirmNewPassword,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 400,
              child: CustomTextField(
                label: '',
                hint: AppStrings.confirmNewPassword,
                suffixIcon: Icons.lock_outline,
                controller: _confirmNewPassword,
                backgroundColor: AppColors.ResetPasswordBackgroundTextField,
                isPassword: true,
                hintStyle: AppTextStyles.confirmNewPassword,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              height: 50,
              child: PrimaryButton(
                text: AppStrings.sendotp,
                onPressed: _handleNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
