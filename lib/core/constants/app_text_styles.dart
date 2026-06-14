import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String  _fontFamily ='IBMPlexSansArabic';
 
 static const TextStyle header = TextStyle(
  fontFamily: _fontFamily,
  fontSize:  28,
  fontWeight: FontWeight.w700,
  color: AppColors.textDark,
  height: 35/28
 );
 static const TextStyle text16_400L = TextStyle(
  fontFamily: _fontFamily,
  fontSize:  16,
  fontWeight: FontWeight.w400,
  color: AppColors.textLight,
 );
 static const TextStyle text16_600L = TextStyle(
  fontFamily: _fontFamily,
  fontSize:  16,
  fontWeight: FontWeight.w600,
  color: AppColors.buttonText,
 );
 static const TextStyle text14_400 = TextStyle(
  fontFamily: _fontFamily,
  fontSize:  14,
  fontWeight: FontWeight.w400,
  color: AppColors.textLight,
 );

}