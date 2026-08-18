import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  final FlutterTts _tts = FlutterTts();
  bool _isReading = false;
  Future<void>? _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initTts();
  }

  bool _isAvailable(dynamic value) {
    return value == true || value == 1 || value == '1' || value == 'true';
  }

  bool _isSpeakOk(dynamic result) {
    return result == 1 || result == true || result == '1';
  }

  Future<void> _initTts() async {
    _tts.setStartHandler(() {
      if (mounted) setState(() => _isReading = true);
    });

    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isReading = false);
    });

    _tts.setCancelHandler(() {
      if (mounted) setState(() => _isReading = false);
    });

    _tts.setErrorHandler((message) {
      print('TTS error: $message');
      if (mounted) setState(() => _isReading = false);
    });

    try {
      final engines = await _tts.getEngines;
      print('TTS engines: $engines');
      if (engines is List && engines.isNotEmpty) {
        final engineList = engines.map((e) => e.toString()).toList();
        final googleEngine = engineList.firstWhere(
          (engine) => engine.contains('google'),
          orElse: () => engineList.first,
        );
        await _tts.setEngine(googleEngine);
      }
    } catch (e) {
      print('TTS engine error: $e');
    }

    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);

    const languages = ['ar-SA', 'ar-EG', 'ar-XA', 'ar', 'ar-AE'];
    for (final language in languages) {
      try {
        final available = await _tts.isLanguageAvailable(language);
        print('TTS language $language = $available');
        if (_isAvailable(available)) {
          await _tts.setLanguage(language);
          return;
        }
      } catch (e) {
        print('TTS language error $language: $e');
      }
    }

    await _tts.setLanguage('ar');
  }

  @override
  void didUpdateWidget(CookingReadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.instruction != widget.instruction) {
      _tts.stop();
      setState(() => _isReading = false);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleRead() async {
    if (_isReading) {
      await _tts.stop();
      if (mounted) setState(() => _isReading = false);
      return;
    }

    final text = widget.instruction.trim();
    if (text.isEmpty) return;

    await (_initFuture ??= _initTts());
    if (!mounted) return;

    setState(() => _isReading = true);
    final result = await _tts.speak(text);
    print('TTS speak result: $result');

    if (!_isSpeakOk(result) && mounted) {
      setState(() => _isReading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تشغيل القراءة. ثبّتي Google Text-to-speech وصوت العربية من إعدادات الجهاز',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
