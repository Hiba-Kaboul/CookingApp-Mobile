import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../pages/categories_page.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final List<String> categories = [
    "الكل",
    "سوري",
    "لبناني",
    "ايطالي",
    "اردني",
    "فلسطيني"
  ];
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
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // مهم جداً للغة العربية
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoriesPage(
                        id: index,
                        categoryName: categories[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? AppColors.primary
                        : const Color(0xFFF3E5E0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
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
        ),
      ],
    );
  }
}
