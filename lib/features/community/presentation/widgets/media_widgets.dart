import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../data/model/users_model.dart';

class PostMediaWidget extends StatefulWidget {
  final List<MediaModel> media;
  const PostMediaWidget({super.key, required this.media});

  @override
  State<PostMediaWidget> createState() => _PostMediaWidgetState();
}

class _PostMediaWidgetState extends State<PostMediaWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return const SizedBox();

    return Column(
      children: [
        // السلايدر
        CarouselSlider.builder(
          itemCount: widget.media.length,
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0, // لتأخذ الصورة عرض الشاشة بالكامل
            enableInfiniteScroll: false,
            scrollPhysics: const PageScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return _buildMedia(widget.media[index]);
          },
        ),

        // الدوائر (Indicators) - تظهر فقط إذا كان هناك أكثر من صورة
        if (widget.media.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.media.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key ? Colors.black : Colors.grey.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildMedia(MediaModel item) {
    return item.type == 'video'
        ? Container(color: Colors.black, child: const Icon(Icons.play_circle, color: Colors.white, size: 50))
        : Image.network(item.url, fit: BoxFit.cover, width: double.infinity);
  }
}