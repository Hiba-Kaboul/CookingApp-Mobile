import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/categories_models.dart';



class CategorySelector extends StatefulWidget {

  final List<CategoryModel> categories;
  final Function(CategoryModel) onSelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onSelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
 
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true, // مهم جداً للغة العربية
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
    
          widget.onSelected(widget.categories[index],);
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
             widget.categories[index].name,
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
}
