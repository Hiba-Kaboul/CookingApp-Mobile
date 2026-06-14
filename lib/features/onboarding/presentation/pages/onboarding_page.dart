import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/onboarding/data/onbording_data.dart';
import 'package:project2/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:project2/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:project2/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:project2/features/onboarding/presentation/widgets/onboarding_page_view.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        Future.delayed(const Duration(milliseconds: 50), () {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              state.currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      },
      builder: (context, state) {
        return Scaffold(
          body: OnboardingPageView(
            pages: OnboardingData.pages,
            currentIndex: state.currentIndex,
            pageController: _pageController,
            onNext: () => context.read<OnboardingBloc>().add(NextPageEvent()),
            onSkip: () => context.read<OnboardingBloc>().add(SkipEvent()),
          ),
        );
      },
    );
  }
}
