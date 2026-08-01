import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/like_recipe_model.dart';

class LikeRecipeApi {
  final Dio dio = Dio();

  Future<LikeRecipe> likeRecipe(int id) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/recipes/$id/like",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return LikeRecipe.fromMap(response.data);
  }
}