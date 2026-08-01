import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/recipe_posts_model.dart';

class RecipesApi {
  final Dio dio = Dio();

  Future<RecipesResponse> getRecipes({int page = 1}) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/recipes",
      queryParameters: {"page": page},
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return RecipesResponse.fromMap(response.data);
  }
}