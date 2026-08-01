import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/add_recipe_comment_model.dart';

class AddRecipeCommentApi {
  final Dio dio = Dio();

  Future<AddRecipeComment> addComment({
    required int recipeId,
    required String body,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/recipes/$recipeId/comments",
      data: {
        "body": body,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return AddRecipeComment.fromMap(response.data);
  }
}