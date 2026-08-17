import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      backgroundColor: AppColors.background,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_rounded),
          activeIcon: Icon(Icons.group_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle),
          label: '',
        ),
        BottomNavigationBarItem(
          
          icon: ImageIcon(
            AssetImage(
                "assets/images/Container (1).png"),
            size: 24,
          ),
     
          activeIcon: ImageIcon(
            AssetImage(
                "assets/images/Container (1).png"), 
            size: 24,
            color: AppColors
                .primary, 
          ),
          label: ' ',
        ),
           BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_sharp),
          activeIcon: Icon(Icons.shopping_cart_sharp),
          label: '',

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: ' ',
        ),
     
      ],
    );
  }
}
