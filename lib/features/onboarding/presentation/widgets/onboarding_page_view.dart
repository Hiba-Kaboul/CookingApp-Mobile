import 'package:flutter/material.dart';
import 'package:project2/features/onboarding/data/models/onboarding_model.dart';
import 'onboarding_content.dart';
import 'onboarding_image.dart';

class OnboardingPageView extends StatelessWidget {
  final List<OnboardingModel> pages;
  final int currentIndex;
  final PageController pageController;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingPageView({
    super.key,
    required this.pages,
    required this.currentIndex,
    required this.pageController,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            // الصورة + زر تخطى
            OnboardingImage(
              image: pages[index].image,
              onSkip: onSkip,
              showSkip: currentIndex < pages.length - 1,
            ),

            // الـ badge لو موجود
            if (pages[index].badge != null)
              Positioned(
                bottom: 310,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.restaurant_menu,
                            color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          pages[index].badge!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // المحتوى في الأسفل
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: OnboardingContent(
                model: pages[index],
                currentIndex: currentIndex,
                totalPages: pages.length,
                onNext: onNext,
              
              ),
            ),
          ],
        );
      },
    );
  }
}