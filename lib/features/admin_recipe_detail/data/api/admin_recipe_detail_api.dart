import 'package:dio/dio.dart';
import 'package:project2/core/utils/token_storage.dart';

import '../../../../core/constants/api_url.dart';
import '../models/admin_recipe_detail_model.dart';

class AdminRecipeDetailApi {
  final Dio dio = Dio();

  Future<AdminRecipeDetailModel> getRecipeDetail(int id) async {
    try {
      final token = await TokenStorage.getToken();

      final response = await dio.get(
        "${ApiUrl.baseUrl}/recipes/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return AdminRecipeDetailModel.fromJson(response.data["data"]);
      } else {
        throw Exception("Failed to load recipe details");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "حدث خطأ أثناء جلب التفاصيل",
      );
    }
  }
}
