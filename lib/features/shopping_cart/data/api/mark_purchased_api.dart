// data/api/mark_purchased_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/mark_purchased_model.dart';

class MarkPurchasedApi {
  final Dio dio = Dio();

  Future<MarkPurchasedResponse> markPurchased(List<int> ids) async {
    final token = await TokenStorage.getToken();

    final response = await dio.patch(
      "${ApiUrl.baseUrl}/shopping-list/purchased",
      data: {
        "ids": ids,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return MarkPurchasedResponse.fromMap(response.data);
  }
}