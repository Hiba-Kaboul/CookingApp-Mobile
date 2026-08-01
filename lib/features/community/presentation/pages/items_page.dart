import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/api_url.dart';
import 'package:project2/features/community/data/api/recipe_api.dart';
import 'package:project2/features/community/presentation/bloc/recipe/recipe_bloc.dart';
import 'package:project2/features/community/presentation/bloc/recipe/recipe_event.dart';
import 'package:project2/features/community/presentation/bloc/recipe/recipe_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/carditems.dart';


class ItemsPage extends StatelessWidget {
  const ItemsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });
  final int categoryId;
  final String categoryName;
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.background,
  //     appBar: AppBar(
  //       iconTheme: const IconThemeData(color: Colors.white),
  //       backgroundColor: AppColors.primary,
  //       centerTitle: true,
  //       title: const Padding(
  //         padding: EdgeInsets.all(20.0),
  //         child: Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             'الوصفات',
  //             style: AppTextStyles.appBarTitle,
  //           ),
  //         ),
  //       ),
  //     ),
  //     body: ListView.builder(
  //       itemCount: 9,
  //       itemBuilder:(context, index) {
  //       return Carditems();
  //     },)
  //   );
  // }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final dio = Dio(
          BaseOptions(
            baseUrl: ApiUrl.baseUrl,
          ),
        );

        return RecipeBloc(
          RecipeApi(dio),
        )..add(GetRecipesEvent(categoryId));
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "الوصفات",
                style: AppTextStyles.appBarTitle,
              ),
            ),
          ),
        ),
        body: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is RecipeError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is RecipeLoaded) {
              return ListView.builder(
                itemCount: state.recipes.length,
                itemBuilder: (context, index) {
                  return Carditems(
                    recipe: state.recipes[index],
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
