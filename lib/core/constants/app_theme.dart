import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        background: AppColors.background,
        surface: AppColors.buttonText,
      ),
      fontFamily: 'YourFont', // إذا عندك خط مخصص
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.background,
      primaryColor: AppColorsDark.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColorsDark.primary,
        background: AppColorsDark.background,
        surface: AppColorsDark.buttonText,
      ),
      fontFamily: 'YourFont',
    );
  }
}