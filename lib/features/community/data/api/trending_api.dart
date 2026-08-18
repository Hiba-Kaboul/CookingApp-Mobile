import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../model/trending_model.dart';

class TrendingApi {
  final Dio dio = Dio();

  Future<TrendingResponse> getTrending() async {
    final token = await TokenStorage.getToken();

    final response = await dio.get(
      "${ApiUrl.baseUrl}/trending",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    return TrendingResponse.fromMap(response.data);
  }
}
