// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
class TextformFiels extends StatefulWidget {
  const TextformFiels({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextEditingController controller;

  @override
  State<TextformFiels> createState() => _TextformFielsState();
}

class _TextformFielsState extends State<TextformFiels> {
  bool isEnabled = false; 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(widget.label, style: AppTextStyles.label),
        ),
        Row(
          children: [
            Expanded( 
              child: TextField(
                enabled: isEnabled, 
                controller: widget.controller,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            IconButton(
              icon: Icon(isEnabled ? Icons.check : Icons.edit, color:AppColors.primary),
              onPressed: () {
                setState(() {
                  isEnabled = !isEnabled; 
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}