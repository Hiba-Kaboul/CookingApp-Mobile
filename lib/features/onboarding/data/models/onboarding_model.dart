class OnboardingModel {
  final String image;
  final String title;
  final String subtitle;
  final String? badge;

  const OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
    this.badge,
  });
}