import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';

enum RecipeTab {
  reviews,
  steps,
  ingredients,
}

class RecipeTabsWidget extends StatelessWidget {
  final RecipeTab selectedTab;

  final Function(RecipeTab) onChanged;

  const RecipeTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = {
      //RecipeTab.reviews: "التقييمات",
      RecipeTab.steps: "الخطوات",
      RecipeTab.ingredients: "المكونات",
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: tabs.entries.map((entry) {
        final selected = entry.key == selectedTab;

        return GestureDetector(
          onTap: () {
            onChanged(entry.key);
          },
          child: Column(
            children: [
              Text(
                entry.value,
                style: selected
                    ? AppTextStyles.title.copyWith(
                        color: AppColors.primary,
                      )
                    : AppTextStyles.subHeading,
              ),
              const SizedBox(height: 6),
              Container(
                height: 3,
                width: 50,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
