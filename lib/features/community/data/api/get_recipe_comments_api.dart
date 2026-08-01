import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/recipe_comments_list_model.dart';

class GetRecipeCommentsApi {
  final Dio dio = Dio();

  Future<RecipeCommentsResponse> getComments({
    required int recipeId,
    int page = 1,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/recipes/$recipeId/comments",
      queryParameters: {"page": page},
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return RecipeCommentsResponse.fromMap(response.data);
  }
}