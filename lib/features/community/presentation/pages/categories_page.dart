import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/api_url.dart';
import 'package:project2/features/community/data/api/category_api.dart';
import 'package:project2/features/community/presentation/bloc/category/category_bloc.dart';
import 'package:project2/features/community/presentation/bloc/category/category_event.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/gridview.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
    required this.id,
    required this.categoryName,
  });

  final int id;
  final String categoryName;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          final dio = Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
            ),
          );

          return CategoryBloc(
            CategoryApi(dio),
          )..add(GetCategoriesEvent(widget.id));
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            centerTitle: true,
            title: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'التصنيفات',
                  style: AppTextStyles.appBarTitle,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Center(
                child: Text(
                  "${widget.categoryName}",
                  style: AppTextStyles.title.copyWith(
                    fontSize: 20,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 700,
                child: Gridview(
                  categoryName: widget.categoryName,
                ),
              )
            ],
          ),
        ));
  }
}
