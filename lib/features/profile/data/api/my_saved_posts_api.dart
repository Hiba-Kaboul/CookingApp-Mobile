import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../models/saved_item_model.dart';

class SavedItemsApi {
  final Dio dio = Dio();

  Future<SavedItemsResponse> getSavedItems() async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/saved",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    return SavedItemsResponse.fromMap(response.data);
  }
}