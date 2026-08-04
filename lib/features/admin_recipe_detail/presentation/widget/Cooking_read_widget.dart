
import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';

class CookingReadWidget extends StatefulWidget {
  final String instruction;

  const CookingReadWidget({
    super.key,
    required this.instruction,
  });

  @override
  State<CookingReadWidget> createState() => _CookingReadWidgetState();
}

class _CookingReadWidgetState extends State<CookingReadWidget> {
 // final FlutterTts _tts = FlutterTts();
  bool _isReading = false;

  @override
  // void initState() {
  //   super.initState();
  //   _tts.setLanguage('ar-SA');
  //   _tts.setSpeechRate(0.5);
  //   _tts.setVolume(1.0);

  //   _tts.setCompletionHandler(() {
  //     if (mounted) setState(() => _isReading = false);
  //   });
  // }

  @override
  void didUpdateWidget(CookingReadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لما تتغير الخطوة، وقفي القراءة تلقائياً
    if (oldWidget.instruction != widget.instruction) {
     // _tts.stop();
      setState(() => _isReading = false);
    }
  }

  @override
  void dispose() {
   // _tts.stop();
    super.dispose();
  }

  Future<void> _toggleRead() async {
    if (_isReading) {
    //  await _tts.stop();
      setState(() => _isReading = false);
    } else {
      setState(() => _isReading = true);
    //  await _tts.speak(widget.instruction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // دائرة الأيقونة
        GestureDetector(
          onTap: _toggleRead,
          child: Container(
            width: 130,
            height: 130,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isReading ? AppColors.followButton : AppColors.primary,
                width: 4,
              ),
              color: Colors.white.withOpacity(0.05),
            ),
            child: Icon(
              _isReading ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: _isReading ? AppColors.followButton : Colors.white,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // نص الزر
        InkWell(
          onTap: _toggleRead,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isReading ? Icons.stop : Icons.play_arrow,
                  color: AppColors.followButton,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  _isReading ? 'إيقاف القراءة' : 'قراءة الخطوة',
                  style: const TextStyle(
                    color: AppColors.followButton,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}