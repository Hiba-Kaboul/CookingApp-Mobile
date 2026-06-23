import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/primary_button.dart';
import 'login_page.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool isOtpComplete = false;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  static const int _initialSeconds = 60;
  int _secondsLeft = _initialSeconds;
  Timer? _timer;
  bool get _isExpired => _secondsLeft <= 0;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(6, (_) => TextEditingController());
    focusNodes = List.generate(6, (_) => FocusNode());

    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = _initialSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _formattedTime {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void checkOtp() {
    bool complete = controllers.every((c) => c.text.isNotEmpty);

    setState(() {
      isOtpComplete = complete;
    });
  }

  String get _otpCode => controllers.map((c) => c.text).join();

  void _clearOtpFields() {
    for (final c in controllers) {
      c.clear();
    }
    setState(() => isOtpComplete = false);
    focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  Widget buildOtpField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            focusNodes[index + 1].requestFocus();
          }

          if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }

          checkOtp();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerifyOtpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تفعيل الحساب بنجاح، سجل دخولك الآن'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          } else if (state is ResendOtpSuccess) {
            _clearOtpFields();
            _startTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إرسال رمز جديد إلى بريدك'),
                backgroundColor: Colors.red,
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
          final isLoading = state is AuthLoading;

          return Scaffold(
            appBar: AppBar(),
            backgroundColor: AppColors.background,
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.otpGradientTop,
                    AppColors.otpGradientMiddle,
                    AppColors.otpGradientBottom,
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.otpCardBackground,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          AppStrings.otpTitle,
                          style: AppTextStyles.heading,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${AppStrings.otpSubtitle}\n${widget.email}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subHeading,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (index) => buildOtpField(index),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // دائرة التايمر
                        Container(
                          width: 70,
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isExpired
                                  ? AppColors.grey
                                  : AppColors.primary,
                              width: 3,
                            ),
                          ),
                          child: Text(
                            _isExpired ? '00:00' : _formattedTime,
                            style: TextStyle(
                              color: _isExpired
                                  ? AppColors.grey
                                  : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // زر إعادة الإرسال
                        TextButton(
                          onPressed: _isExpired && !isLoading
                              ? () {
                                  context.read<AuthBloc>().add(
                                        ResendOtpRequested(email: widget.email),
                                      );
                                }
                              : null,
                          child: Text(
                            AppStrings.resendCode,
                            style: AppTextStyles.link.copyWith(
                              color: _isExpired
                                  ? AppColors.primary
                                  : AppColors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.primary,
                              )
                            : PrimaryButton(
                                text: AppStrings.verify,
                                onPressed: isOtpComplete
                                    ? () {
                                        context.read<AuthBloc>().add(
                                              VerifyOtpSubmitted(
                                                email: widget.email,
                                                code: _otpCode,
                                              ),
                                            );
                                      }
                                    : null,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
