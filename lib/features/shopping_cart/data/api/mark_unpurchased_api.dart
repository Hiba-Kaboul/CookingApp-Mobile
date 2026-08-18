// data/api/mark_unpurchased_api.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/mark_unpurchased_model.dart';

class MarkUnpurchasedApi {
  final Dio dio = Dio();

  Future<MarkUnpurchasedResponse> markUnpurchased(List<int> ids) async {
    final token = await TokenStorage.getToken();

    final response = await dio.patch(
      "${ApiUrl.baseUrl}/shopping-list/unpurchased",
      data: {
        "ids": ids,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return MarkUnpurchasedResponse.fromMap(response.data);
  }
}