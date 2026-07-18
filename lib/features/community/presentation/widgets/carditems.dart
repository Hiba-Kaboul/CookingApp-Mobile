import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class Carditems extends StatelessWidget {
  const Carditems({super.key});

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
                child: Image.asset(
                  "assets/images/onboarding3.png",
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                  // errorBuilder: (context, error, stackTrace) {
                  //   return Image.asset(
                  //     "assets/images/عصير برتقال طبيعي.jpg",
                  //     width: 95,
                  //     height: 95,
                  //     fit: BoxFit.cover,
                  //   );
                  // },
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
                const  SizedBox(
                    width: 120,
                    child: Text(
                      " وصفة كوسا",
                      style: AppTextStyles.names,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                    const  SizedBox(
                        width: 120,
                        child: Text("اسم الشيف",
                            style: AppTextStyles.otpDescription),
                      ),
                      SizedBox(width: 50,),
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
               const   Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 20,
                        color: Color(0xEf436850),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "25",
                        style: TextStyle(
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
