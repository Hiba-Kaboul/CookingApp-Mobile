import 'package:dio/dio.dart';

import '../models/recipe_model.dart';

class RecipeApi {
  final Dio dio;

  RecipeApi(this.dio);

  Future<List<RecipeModel>> getRecipes(int categoryId) async {
    final response = await dio.get(
      "/recipes",
      queryParameters: {
        "category": categoryId,
      },
    );

    final List data = response.data["data"];

    return data
        .map((e) => RecipeModel.fromJson(e))
        .toList();
  }
}