import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class Profiletop extends StatelessWidget {
  final String imageUrl;

  const Profiletop({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [

        Center(
          child: Container(
            height: 110,
            width: double.infinity,
            color: AppColors.primary,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset("assets/images/Icon.png"),
            ),
          ),
        ),

        if (imageUrl.isNotEmpty)
          Positioned(
            bottom: -80,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(70),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.network(
                  imageUrl,
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
