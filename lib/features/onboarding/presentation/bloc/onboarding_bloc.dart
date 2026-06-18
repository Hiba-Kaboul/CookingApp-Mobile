

import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<NextPageEvent>(_onNextPage);
    on<SkipEvent>(_onSkip);
  }

  final int _totalPages = 3;

  void _onNextPage(NextPageEvent event, Emitter<OnboardingState> emit) {
    if (state.currentIndex < _totalPages - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void _onSkip(SkipEvent event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(currentIndex: _totalPages - 1));
  }
}