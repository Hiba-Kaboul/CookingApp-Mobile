import 'package:flutter/material.dart';

class Photo extends StatelessWidget {
  const Photo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // تدوير الكارد نفسه
        child: Container(
          width: screenWidth * 0.9,
          height: 150,
          // لا داعي للـ Expanded هنا
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // مطابقة تدوير الكارد
            child: Image.asset(
              "assets/images/Backdrop.png",
              fit: BoxFit.cover, 
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}