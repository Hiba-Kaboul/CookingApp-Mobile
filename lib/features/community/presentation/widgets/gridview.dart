import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/community/presentation/bloc/category/category_bloc.dart';
import 'package:project2/features/community/presentation/bloc/category/category_state.dart';

import '../../../../core/constants/app_colors.dart';
import '../pages/items_page.dart';

class Gridview extends StatefulWidget {
  const Gridview({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  State<Gridview> createState() => _GridviewState();
}

class _GridviewState extends State<Gridview> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is CategoryError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is CategoryLoaded) {
          final categories = state.categories;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 4 / 3.5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final bool isSelected = index == selectedIndex;

              return InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemsPage(
                        categoryId: category.id,
                        categoryName: category.name,
                      ),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      image: NetworkImage(category.image),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.otpGradientTop
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.otpGradientTop.withOpacity(0.85),
                          ],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
