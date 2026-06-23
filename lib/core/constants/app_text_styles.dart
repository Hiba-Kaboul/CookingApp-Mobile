import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'IBMPlexSansArabic';

  static const TextStyle header = TextStyle(
      fontFamily: _fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.textDark,
      height: 35 / 28);
  static const TextStyle text16_400L = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );
  static const TextStyle text16_600L = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
  );

  static const TextStyle text14_400 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 13,
    color: AppColors.textLight,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 13,
    color: AppColors.hintText,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonText,
  );

  static const TextStyle link = TextStyle(
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonText,
  );
  static const TextStyle passwordtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  ///Reset
  static const TextStyle appBarChangepassword = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.buttonText,
  );
  static const TextStyle confirmNewPassword = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.hintText,
  );
  static const TextStyle Update = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  // AppBar
  static const TextStyle appBarTitle2 = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // OTP Page
  static const TextStyle otpTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle otpDescription = TextStyle(
    fontSize: 14,
    color: Colors.black54,
    height: 1.6,
  );

  static const TextStyle otpButton = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle otpNotReceived = TextStyle(
    color: Colors.black54,
    fontSize: 15,
  );

  static TextStyle otpResend = TextStyle(
    color: AppColors.primary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );

  static const TextStyle otpResendDisabled = TextStyle(
    color: Colors.grey,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    decorationColor: Colors.grey,
  );

  static TextStyle otpTimer = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
}
