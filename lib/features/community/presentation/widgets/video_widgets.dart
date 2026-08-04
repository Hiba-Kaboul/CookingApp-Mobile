import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class PostVideoWidget extends StatefulWidget {
  final String url;
  final bool autoPlay;

  const PostVideoWidget({
    super.key,
    required this.url,
    required this.autoPlay,
  });

  @override
  State<PostVideoWidget> createState() => _PostVideoWidgetState();
}

class _PostVideoWidgetState extends State<PostVideoWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    )..initialize().then((_) {
        controller.setLooping(true);

        if (widget.autoPlay) {
          controller.play();
        }

        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant PostVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.autoPlay != oldWidget.autoPlay) {
      if (widget.autoPlay) {
        controller.play();
      } else {
        controller.pause();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [

        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),

        IconButton(
          iconSize: 60,
          color: Colors.white,
          onPressed: () {

            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }

            setState(() {});
          },
          icon: Icon(
            controller.value.isPlaying
                ? Icons.pause_circle
                : Icons.play_circle,
          ),
        ),
      ],
    );
  }
}