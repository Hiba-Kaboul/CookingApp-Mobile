// data/api/shopping_list_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/shopping_item_model.dart';

class ShoppingListApi {
  final Dio dio = Dio();

  Future<ShoppingListResponse> getShoppingList() async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/shopping-list",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ShoppingListResponse.fromMap(response.data);
  }
}