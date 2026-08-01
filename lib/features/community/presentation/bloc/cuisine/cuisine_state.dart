import 'package:project2/features/community/data/models/cuisine_model.dart';

abstract class CuisineState {}

class CuisineInitial extends CuisineState {}

class CuisineLoading extends CuisineState {}

class CuisineLoaded extends CuisineState {
  final List<CuisineModel> cuisines;

  CuisineLoaded(this.cuisines);
}

class CuisineError extends CuisineState {
  final String message;

  CuisineError(this.message);
}
