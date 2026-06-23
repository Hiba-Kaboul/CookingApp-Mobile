import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_strings.dart';
import 'package:project2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:project2/features/auth/presentation/bloc/auth_event.dart';
import 'package:project2/features/auth/presentation/bloc/auth_state.dart';
import 'package:project2/features/auth/presentation/pages/otp_page_forget.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            AppStrings.appBarpassword,
            style: AppTextStyles.appBarTitle,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.buttonText,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: BlocProvider(
              create: (_) => AuthBloc(),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is ForgetPasswordSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtpPageForget(email: state.email),
                      ),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/forgotpassword.png",
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.passwordtitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          AppStrings.emailtitle,
                          style: AppTextStyles.label,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: CustomTextField(
                          label: AppStrings.email,
                          hint: AppStrings.emailHint,
                          suffixIcon: Icons.email_outlined,
                          controller: _emailController,
                        ),
                      ),
                      const SizedBox(height: 40),
                      state is AuthLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.primary)
                          : PrimaryButton(
                              text: AppStrings.sendCode,
                              onPressed: () {
                                if (_emailController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('أدخل البريد الإلكتروني')),
                                  );
                                  return;
                                }
                                context.read<AuthBloc>().add(
                                      ForgotPasswordSubmitted(
                                        email: _emailController.text.trim(),
                                      ),
                                    );
                              },
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        )));
  }
}
