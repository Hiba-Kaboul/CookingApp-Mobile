import 'package:dio/dio.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../core/utils/token_storage.dart';
import '../models/create_post_request_model.dart';
import '../models/create_post_response_model.dart';

class CreatePostApi {
  final Dio dio = Dio();

  Future<CreatePostResponseModel> createPost(
      CreatePostRequestModel request) async {
    try {
      final token = await TokenStorage.getToken();
      // المعلومات العادية
      final formData = FormData.fromMap({
        "title": request.title,
        "description": request.description,
        "category_id": request.categoryId,
        "duration_minutes": request.durationMinutes,
        "servings": request.servings,
      });

      // إضافة الخطوات
      for (int i = 0; i < request.steps.length; i++) {
        formData.fields.add(
          MapEntry(
            "steps[$i][order]",
            request.steps[i].order.toString(),
          ),
        );

        formData.fields.add(
          MapEntry(
            "steps[$i][description]",
            request.steps[i].description,
          ),
        );
      }

      // إضافة المكونات
      for (int i = 0; i < request.ingredients.length; i++) {
        formData.fields.add(
          MapEntry(
            "ingredients[$i][name]",
            request.ingredients[i].name,
          ),
        );

        formData.fields.add(
          MapEntry(
            "ingredients[$i][quantity]",
            request.ingredients[i].quantity,
          ),
        );
      }

      // إضافة الصور والفيديو
      for (final file in request.media) {
        final name = file.path.split(RegExp(r'[\\/]')).last;
        final isVideo = name.toLowerCase().endsWith('.mp4') ||
            name.toLowerCase().endsWith('.mov');

        formData.files.add(
          MapEntry(
            "media[]",
            await MultipartFile.fromFile(
              file.path,
              filename: name,
              contentType: isVideo
                  ? DioMediaType('video', 'mp4')
                  : DioMediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await dio.post(
        "${ApiUrl.baseUrl}/posts",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          sendTimeout: const Duration(minutes: 3),
          receiveTimeout: const Duration(minutes: 3),
        ),
      );

      return CreatePostResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print("DIO TYPE: ${e.type}");
      print("DIO MESSAGE: ${e.message}");
      print("STATUS CODE: ${e.response?.statusCode}");
      print("RESPONSE: ${e.response?.data}");
      rethrow;
    }
  }
}
