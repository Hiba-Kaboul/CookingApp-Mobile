import 'package:project2/core/constants/app_strings.dart';
import 'models/onboarding_model.dart';

class OnboardingData {
  OnboardingData._();

  static const List<OnboardingModel> pages = [
    OnboardingModel(
      image: 'assets/images/onboarding1.png',
      title: AppStrings.onboarding1Title,
      subtitle: AppStrings.onboarding1Subtitle,
      badge: null,
    ),
    OnboardingModel(
      image: 'assets/images/onboarding2.png',
      title: AppStrings.onboarding2Title,
      subtitle: AppStrings.onboarding2Subtitle,
      badge: AppStrings.onboarding2Badge,
    ),
    OnboardingModel(
      image: 'assets/images/onboarding3.png',
      title: AppStrings.onboarding3Title,
      subtitle: AppStrings.onboarding3Subtitle,
      badge: null,
    ),
  ];
}