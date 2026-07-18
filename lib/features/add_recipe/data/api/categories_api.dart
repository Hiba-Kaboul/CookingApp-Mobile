import 'package:dio/dio.dart';
import '../../../../../core/constants/api_url.dart';
import '../../../../../core/utils/token_storage.dart';
import '../models/categories_models.dart';

class CategoriesApi {
  final Dio dio = Dio();

  Future<CategoriesModel> getCategories() async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/categories",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return CategoriesModel.fromJson(response.data);
  }
}