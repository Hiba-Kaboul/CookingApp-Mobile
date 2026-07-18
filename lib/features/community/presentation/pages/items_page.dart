import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/carditems.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'الوصفات',
              style: AppTextStyles.appBarTitle,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 9,
        itemBuilder:(context, index) {
        return Carditems();
      },)
    );
  }
}
