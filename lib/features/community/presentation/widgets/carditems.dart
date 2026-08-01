import 'package:flutter/material.dart';
import 'package:project2/features/community/data/models/recipe_model.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class Carditems extends StatelessWidget {
  const Carditems({
    super.key,
    required this.recipe,
  });
  final RecipeModel recipe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        shadowColor: AppColors.primary,
        elevation: 10,
        child: Row(
          children: [
            Card(
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // نفس نصف قطر Card
                child: Image.network(
                  recipe.images.isNotEmpty
                      ? recipe.images.first
                      : "https://via.placeholder.com/150",
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 120,
                    child: Text(
                      recipe.name,
                      style: AppTextStyles.names,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(recipe.chefName,
                            style: AppTextStyles.otpDescription),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(
                          //         builder: (context) {
                          //   return DetailsPage(
                          //       id: snapshot.data![index].id);
                          // }));
                        },
                        child: const Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ],
                  ),
                   Row(
                    children: [
                     const Icon(
                        Icons.access_time_rounded,
                        size: 20,
                        color: Color(0xEf436850),
                      ),
                     const SizedBox(width: 5),
                      Text(
                        "${recipe.prepTime}",
                        style:const TextStyle(
                          fontFamily: 'AncizarSerif',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
