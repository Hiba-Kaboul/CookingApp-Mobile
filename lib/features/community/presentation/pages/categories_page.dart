import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/gridview.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
    required this.id,
    required this.categoryName,
  });

  final int id;
  final String categoryName;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
              'التصنيفات',
              style: AppTextStyles.appBarTitle,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text("${widget.id} - ${widget.categoryName}"),
          ),
          SizedBox(
            height: 700,
            child: Gridview(
              categoryName: widget.categoryName,
            ),
          )
        ],
      ),
    );
  }
}
