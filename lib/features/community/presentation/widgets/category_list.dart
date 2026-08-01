import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/features/community/presentation/bloc/cuisine/cuisine_bloc.dart';
import 'package:project2/features/community/presentation/bloc/cuisine/cuisine_state.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../pages/categories_page.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            AppStrings.type_kitchens,
            style: AppTextStyles.title,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // SizedBox(
        //   width: double.infinity,
        //   height: 40,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     reverse: true, // مهم جداً للغة العربية
        //     itemCount: categories.length,
        //     itemBuilder: (context, index) {
        //       return InkWell(
        //         onTap: () {
        //           setState(() {
        //             selectedIndex = index;
        //           });

        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (_) => CategoriesPage(
        //                 id: index,
        //                 categoryName: categories[index],
        //               ),
        //             ),
        //           );
        //         },
        //         child: Container(
        //           margin: const EdgeInsets.symmetric(horizontal: 5),
        //           padding:
        //               const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        //           decoration: BoxDecoration(
        //             color: selectedIndex == index
        //                 ? AppColors.primary
        //                 : const Color(0xFFF3E5E0),
        //             borderRadius: BorderRadius.circular(15),
        //           ),
        //           child: Center(
        //             child: Text(
        //               categories[index],
        //               style: TextStyle(
        //                 color: selectedIndex == index
        //                     ? Colors.white
        //                     : Colors.brown,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        BlocBuilder<CuisineBloc, CuisineState>(
          builder: (context, state) {
            if (state is CuisineLoading) {
              return const SizedBox(
                height: 40,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is CuisineError) {
              return SizedBox(
                height: 40,
                child: Center(
                  child: Text(state.message),
                ),
              );
            }

            if (state is CuisineLoaded) {
              final cuisines = state.cuisines;

              return SizedBox(
                width: double.infinity,
                height: 40,
                child: ListView.builder(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: cuisines.length,
                  itemBuilder: (context, index) {
                    final cuisine = cuisines[index];

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoriesPage(
                              id: cuisine.id,
                              categoryName: cuisine.name,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? AppColors.primary
                              : const Color(0xFFF3E5E0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            cuisine.name,
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Colors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}
