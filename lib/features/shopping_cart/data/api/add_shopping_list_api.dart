import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/add_shopping_item_model.dart';

class AddShoppingItemApi {
  final Dio dio = Dio();

  Future<AddShoppingItemResponse> addIngredient(int ingredientId) async {
    final token = await TokenStorage.getToken();

    final response = await dio.post(
      "${ApiUrl.baseUrl}/shopping-list",
      data: {
        "ingredient_id": ingredientId,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return AddShoppingItemResponse.fromMap(response.data);
  }
}