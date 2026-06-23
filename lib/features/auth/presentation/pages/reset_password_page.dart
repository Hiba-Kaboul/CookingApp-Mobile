import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_strings.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'package:project2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:project2/features/auth/presentation/bloc/auth_event.dart';
import 'package:project2/features/auth/presentation/bloc/auth_state.dart';
import 'package:project2/features/auth/presentation/pages/login_page.dart';
import 'package:project2/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:project2/features/auth/presentation/widgets/primary_button.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email; // ← جديد
  final String code;
  const ResetPasswordPage({super.key, required this.email, required this.code});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newPassword = TextEditingController();
  final _confirmNewPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ResetPasswordTextField,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          title:
              const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              AppStrings.resetTitle,
              style: AppTextStyles.appBarChangepassword,
            ),
          ]),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            color: AppColors.buttonText,
            onPressed: () {
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              );
            },
          )),
      body: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/Space for Branding.png',
              width: 350,
              height: 350,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 400,
            child: CustomTextField(
              label: "",
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
              label: "",
              hint: AppStrings.confirmNewPassword,
              suffixIcon: Icons.lock_outline,
              controller: _confirmNewPassword,
              backgroundColor: AppColors.ResetPasswordBackgroundTextField,
              isPassword: true,
              hintStyle: AppTextStyles.confirmNewPassword,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
              width: 300,
              height: 50,
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: BlocProvider(
                    create: (_) => AuthBloc(),
                    child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                      if (state is ResetPasswordSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تغيير كلمة المرور بنجاح'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    }, builder: (context, state) {
                      return PrimaryButton(
                          text: AppStrings.update,
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_newPassword.text.trim().isEmpty ||
                                      _confirmNewPassword.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'أدخل كلمة المرور وتأكيدها')),
                                    );
                                    return;
                                  }
                                  if (_newPassword.text.trim() !=
                                      _confirmNewPassword.text.trim()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('كلمة المرور غير متطابقة')),
                                    );
                                    return;
                                  }
                                  context.read<AuthBloc>().add(
                                        ResetPasswordSubmitted(
                                          email: widget.email,
                                          code: widget.code,
                                          password: _newPassword.text.trim(),
                                          passwordConfirmation:
                                              _confirmNewPassword.text.trim(),
                                        ),
                                      );
                                });
                    }),
                  )))
        ],
      ),
    );
  }
}
