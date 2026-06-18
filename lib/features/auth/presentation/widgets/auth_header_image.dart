import 'package:flutter/material.dart';

class AuthHeaderImage extends StatelessWidget {
  final String imagePath;

  const AuthHeaderImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}