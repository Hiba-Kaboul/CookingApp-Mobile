// data/api/search_recipes_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';

import '../model/recipe_posts_model.dart';

class SearchRecipesApi {
  final Dio dio = Dio();

  Future<RecipesResponse> searchRecipes(String query) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/recipes",
      queryParameters: {
        "search": query,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return RecipesResponse.fromMap(response.data);
  }
}