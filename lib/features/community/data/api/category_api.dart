import 'package:dio/dio.dart';

import '../models/category_model.dart';

class CategoryApi {
  final Dio dio;

  CategoryApi(this.dio);

  Future<List<CategoryModel>> getCategories(int cuisineId) async {
    try {
      final response =
          await dio.get('/recipe-categories/cuisine/$cuisineId');

      final List data = response.data['data'];

      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to load categories");
    }
  }
}