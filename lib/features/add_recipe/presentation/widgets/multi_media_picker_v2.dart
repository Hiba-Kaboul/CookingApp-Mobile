import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// نوع الوسائط: صورة أو فيديو
enum MediaType { image, video }

class RecipeMedia {
  final File file;
  final MediaType type;

  /// صورة الغلاف (thumbnail) — تُستخدم للعرض بالكاروسيل بدل تشغيل الفيديو الفعلي.
  /// للصور: نفس ملف الصورة. للفيديو: صورة مستخرجة (bytes) من الفيديو.
  Uint8List? thumbnailBytes;

  /// لا يُنشأ إلا لحظة فتح المستخدم للفيديو فعلياً (Lazy Loading)
  VideoPlayerController? videoController;

  RecipeMedia({
    required this.file,
    required this.type,
    this.thumbnailBytes,
  });
}

/// ويدجت اختيار وعرض أكثر من صورة + فيديو للوصفة
/// الفيديو يُعرض كصورة مصغّرة (thumbnail) فقط أثناء التصفح لتوفير الموارد،
/// ولا يُشغَّل الفيديو الفعلي إلا عند الضغط عليه.
class MultiMediaPicker extends StatefulWidget {
  final ValueChanged<List<RecipeMedia>>? onChanged;

  const MultiMediaPicker({super.key, this.onChanged});

  @override
  State<MultiMediaPicker> createState() => _MultiMediaPickerState();
}

class _MultiMediaPickerState extends State<MultiMediaPicker> {
  final List<RecipeMedia> _mediaList = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isProcessing = false; // لإظهار مؤشر تحميل أثناء استخراج thumbnail

  final ImagePicker _picker = ImagePicker();

  // ---------------- اختيار صور ----------------
  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isEmpty) return;

    setState(() {
      for (final img in images) {
        _mediaList.add(
          RecipeMedia(file: File(img.path), type: MediaType.image),
        );
      }
    });
    widget.onChanged?.call(_mediaList);
  }

  // ---------------- اختيار فيديو + استخراج thumbnail فقط ----------------
  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    setState(() => _isProcessing = true);

    // 👇 هون الفرق الأساسي: ما بنفتح VideoPlayerController أبداً بهاي المرحلة.
    // بس بنسحب فريم واحد من الفيديو ونحوّله لصورة (bytes) خفيفة.
    final Uint8List? thumbBytes = await VideoThumbnail.thumbnailData(
      video: video.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 400, // كافية لعرض مصغّر بجودة جيدة وحجم خفيف
      quality: 75,
    );

    final media = RecipeMedia(
      file: File(video.path),
      type: MediaType.video,
      thumbnailBytes: thumbBytes,
    );

    setState(() {
      _mediaList.add(media);
      _isProcessing = false;
    });
    widget.onChanged?.call(_mediaList);
  }

  void _removeMedia(int index) {
    final removed = _mediaList[index];
    removed.videoController?.dispose(); // لو كان انفتح مسبقاً، نحرره
    setState(() {
      _mediaList.removeAt(index);
      if (_currentPage >= _mediaList.length && _currentPage > 0) {
        _currentPage = _mediaList.length - 1;
      }
    });
    widget.onChanged?.call(_mediaList);
  }

  void _showAddMediaSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.image_outlined, color: AppColors.primary),
                  title: const Text('إضافة صور', textAlign: TextAlign.right),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImages();
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.videocam_outlined, color: AppColors.primary),
                  title: const Text('إضافة فيديو', textAlign: TextAlign.right),
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideo();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- فتح الفيديو فعلياً (هون بس بننشئ VideoPlayerController) ----------------
  Future<void> _openVideoFullScreen(RecipeMedia media) async {
    // لو أول مرة بيُفتح هاد الفيديو، ننشئ الـ controller الآن (Lazy)
    if (media.videoController == null) {
      final controller = VideoPlayerController.file(media.file);
      await controller.initialize();
      media.videoController = controller;
      if (mounted) setState(() {}); // لتحديث الواجهة إذا لزم
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            final controller = media.videoController!;
            controller.play();
            return AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(controller),
                  IconButton(
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ).then((_) {
      // نوقف الفيديو (بدون تحرير الـ controller حتى نقدر نفتحه بسرعة مرة ثانية)
      media.videoController?.pause();
    });
  }

  @override
  void dispose() {
    for (final m in _mediaList) {
      m.videoController?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _mediaList.isEmpty ? _buildEmptyState() : _buildCarousel(),
        if (_isProcessing)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_mediaList.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildThumbnailsRow(),
        ],
      ],
    );
  }

  // ------------- حالة عدم وجود أي وسائط بعد -------------
  Widget _buildEmptyState() {
    return GestureDetector(
      onTap: _showAddMediaSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.buttonText,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder, width: 1.4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(Icons.camera_alt, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 10),
            Text('أضف صوراً أو فيديو جذاباً لوصفتك',
                style: AppTextStyles.label.copyWith(fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              'يمكنك إضافة أكثر من صورة، وفيديو واحد على الأقل',
              style: AppTextStyles.hint.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ------------- الكاروسيل الرئيسي: صور + thumbnails للفيديوهات فقط -------------
  Widget _buildCarousel() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _mediaList.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final media = _mediaList[index];
                return GestureDetector(
                  onTap: () {
                    if (media.type == MediaType.video) {
                      _openVideoFullScreen(media);
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // 👇 الفرق الأساسي: الفيديو بيعرض thumbnail بس، مش VideoPlayer شغّال
                      if (media.type == MediaType.image)
                        Image.file(media.file, fit: BoxFit.cover)
                      else if (media.thumbnailBytes != null)
                        Image.memory(media.thumbnailBytes!, fit: BoxFit.cover)
                      else
                        Container(
                          color: Colors.black12,
                          child: const Center(
                              child: CircularProgressIndicator()),
                        ),
                      if (media.type == MediaType.video)
                        Container(
                          color: Colors.black26,
                          child: const Center(
                            child: Icon(Icons.play_circle_fill,
                                color: Colors.white, size: 48),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: GestureDetector(
            onTap: () => _removeMedia(_currentPage),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.black45,
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _showAddMediaSheet,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),
        ),
        if (_mediaList.length > 1)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_mediaList.length, (index) {
                final active = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  // ------------- شريط الصور المصغّرة تحت الكاروسيل -------------
  Widget _buildThumbnailsRow() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: _mediaList.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == _mediaList.length) {
            return GestureDetector(
              onTap: _showAddMediaSheet,
              child: Container(
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.buttonText,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Icon(Icons.add, color: AppColors.primary),
              ),
            );
          }

          final media = _mediaList[index];
          final bool active = index == _currentPage;

          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: active ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (media.type == MediaType.image)
                      Image.file(media.file, fit: BoxFit.cover)
                    else if (media.thumbnailBytes != null)
                      Image.memory(media.thumbnailBytes!, fit: BoxFit.cover)
                    else
                      Container(color: Colors.black12),
                    if (media.type == MediaType.video)
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.play_circle_fill,
                              color: Colors.white, size: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}