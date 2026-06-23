//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project2/features/auth/presentation/pages/forgot_Password_Page.dart';
import 'package:project2/features/auth/presentation/pages/reset_password_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class OtpPageForget extends StatefulWidget {
  final String email;
  const OtpPageForget({super.key, required this.email});

  @override
  State<OtpPageForget> createState() => _OtpPageForgetState();
}

class _OtpPageForgetState extends State<OtpPageForget> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
        }
      });
      return _secondsRemaining > 0;
    });
  }

  String get _timerText {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: const Text(
            AppStrings.otpPageTitle,
            style: AppTextStyles.appBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.buttonText),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage(),
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Image.asset(
                'assets/images/Security Verification Concept.png',
                height: 220,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 28),

              const Text(
                AppStrings.otpTitle,
                style: AppTextStyles.otpTitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              const Text(
                AppStrings.otpDescription,
                style: AppTextStyles.otpDescription,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // حقول OTP مع الانتقال التلقائي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 42,
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => _onChanged(value, index),
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // العداد
              Container(
                width: 70,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
                child: Text(
                  _timerText,
                  style: AppTextStyles.otpTimer,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final code = _controllers.map((c) => c.text).join();
                    if (code.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('أدخل الرمز كاملاً')),
                      );
                      return;
                    }
                    // مش في API call هون — بس نمرر الإيميل والكود للصفحة الجاية
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResetPasswordPage(
                          email: widget.email,
                          code: code,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    AppStrings.otpVerifyButton,
                    style: AppTextStyles.otpButton,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppStrings.otpNotReceived,
                    style: AppTextStyles.otpNotReceived,
                  ),
                  GestureDetector(
                    onTap: _canResend ? _startTimer : null,
                    child: TextButton(
                      child: Text(
                        AppStrings.otpResend,
                        style: _canResend
                            ? AppTextStyles.otpResend
                            : AppTextStyles.otpResendDisabled,
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
