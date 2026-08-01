import 'package:dio/dio.dart';
import 'package:project2/features/community/data/models/cuisine_model.dart';

class CuisineApi {
  final Dio dio;

  CuisineApi(this.dio);

  Future<List<CuisineModel>> getCuisines() async {
    try {
      final response = await dio.get('/cuisines');

      final List data = response.data['data'];

      return data.map((json) => CuisineModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load cuisines');
    }
  }
}
