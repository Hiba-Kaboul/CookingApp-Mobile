import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_text_styles.dart';

import '../../../core/constants/app_colors.dart';

class Carouselslider extends StatelessWidget {
  const Carouselslider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      // width: 256,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 170,
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 0.5,
          autoPlayInterval: const Duration(seconds: 1),
          padEnds: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          enableInfiniteScroll: true,
        ),
        // child: CarouselSlider.builder(
        // key: const PageStorageKey('carousel'),
        // options: CarouselOptions(
        //   height: 170,
        //   autoPlay: true,
        //   enlargeCenterPage: false,
        //   viewportFraction: 0.5,
        //   autoPlayInterval: const Duration(seconds: 3),
        //   padEnds: true,
        //   autoPlayAnimationDuration: const Duration(milliseconds: 1200),
        //   enableInfiniteScroll: false, // الأهم
        // ),
        itemCount: 5,
        itemBuilder: (context, index, realIndex) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 1. الصورة مع التقييم
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                        child: Image.asset("assets/images/onboarding1.png",
                            fit: BoxFit.cover, width: double.infinity),
                      ),
                      // التقييم
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Row(children: [
                            Text("4.8"),
                            Icon(Icons.star, color: Colors.amber, size: 10)
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                // 2. العنوان والوقت
                const Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text("ستيك بصلصة الزبدة والثوم",
                              style: AppTextStyles.title, maxLines: 1),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "25 دقيقة",
                                textAlign: TextAlign.right,
                                style: AppTextStyles.title1,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.light_brown,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
