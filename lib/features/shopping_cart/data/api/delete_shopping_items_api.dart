// data/api/delete_shopping_items_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/delete_shopping_items_model.dart';

class DeleteShoppingItemsApi {
  final Dio dio = Dio();

  Future<DeleteShoppingItemsResponse> deleteItems(List<int> ids) async {
    final token = await TokenStorage.getToken();

    final response = await dio.delete(
      "${ApiUrl.baseUrl}/shopping-list",
      data: {
        "ids": ids,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return DeleteShoppingItemsResponse.fromMap(response.data);
  }
}