import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/save_recipe_model.dart';

class SaveRecipeApi {
  final Dio dio = Dio();

  Future<SaveRecipe> saveRecipe(int id) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/recipes/$id/save",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return SaveRecipe.fromMap(response.data);
  }
}