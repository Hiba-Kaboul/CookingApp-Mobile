import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/share_recipe_model.dart';

class ShareRecipeApi {
  final Dio dio = Dio();

  Future<ShareRecipeResponse> shareRecipe({
    required int recipeId,
    required String platform,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/recipes/$recipeId/share",
      data: {"platform": platform},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    return ShareRecipeResponse.fromMap(response.data);
  }
}