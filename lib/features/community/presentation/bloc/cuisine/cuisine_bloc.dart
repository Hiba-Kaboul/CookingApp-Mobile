import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/cuisine_api.dart';
import 'cuisine_event.dart';
import 'cuisine_state.dart';

class CuisineBloc extends Bloc<CuisineEvent, CuisineState> {
  final CuisineApi cuisineApi;

  CuisineBloc(this.cuisineApi) : super(CuisineInitial()) {

    on<GetCuisinesEvent>((event, emit) async {

      emit(CuisineLoading());

      try {

        final cuisines = await cuisineApi.getCuisines();

        emit(CuisineLoaded(cuisines));

      } catch (e) {

        emit(CuisineError(e.toString()));

      }

    });

  }
}