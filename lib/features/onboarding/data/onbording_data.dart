
import 'models/onboarding_model.dart';

class OnboardingData {
  OnboardingData._();

  static const List<OnboardingModel> pages = [
    OnboardingModel(
      image: 'assets/images/onboarding1.png',
      title: 'عالم من النكهات بين يديك',
      subtitle: 'اكتشف آلاف الوصفات المختارة بعناية لتناسب ذوقك الفريد وتلهم إبداعك في المطبخ.',
      badge: null,
    ),
    OnboardingModel(
      image: 'assets/images/onboarding2.png',
      title: 'اطبخ باحترافية وسهولة',
      subtitle: 'استمتع بتجربة طبخ سلسة مع مساعدنا الذكي الذي يرافقك خطوة بخطوة حتى تصل للنتيجة المثالية.',
      badge: 'مساعد الطبخ الذكي',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding3.png',
      title: 'انضم إلى عائلة هواة الطبخ',
      subtitle: 'شارك وصفاتك الخاصة، وتبادل الخبرات مع مجتمع شغوف بحب الطبخ تقدر ما تحب.',
      badge: null,
    ),
  ];
}