import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/features/admin_recipe_detail/data/models/admin_recipe_detail_model.dart';
import 'package:project2/features/community/presentation/widgets/video_widgets.dart';

class AdminRecipeHeaderWidget extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onBack;
  final List<AdminRecipeMedia> media;

  const AdminRecipeHeaderWidget({
    super.key,
    required this.isFavorite,
    required this.onFavorite,
    required this.onBack,
    required this.media,
  });

  @override
  State<AdminRecipeHeaderWidget> createState() =>
      _AdminRecipeHeaderWidgetState();
}

class _AdminRecipeHeaderWidgetState extends State<AdminRecipeHeaderWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.15,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: widget.media.isEmpty
                  ? Container(
                      color: AppColors.otpCardBackground,
                      child: const Icon(Icons.image, size: 60),
                    )
                  : PageView.builder(
                      itemCount: widget.media.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = widget.media[index];
                        if (item.type == "video") {
                          return PostVideoWidget(
                            url: item.url,
                            autoPlay: _currentIndex == index,
                          );
                        }
                        return Image.network(
                          item.url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stack) {
                            return Container(
                              color: AppColors.otpCardBackground,
                              child: const Icon(Icons.image, size: 60),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
          if (widget.media.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.media.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),
          Positioned(
            top: 16,
            left: 16,
            child: _circleButton(
              icon: Icons.arrow_forward,
              onTap: widget.onBack,
            ),
          ),

        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = AppColors.otpGradientMiddle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}
