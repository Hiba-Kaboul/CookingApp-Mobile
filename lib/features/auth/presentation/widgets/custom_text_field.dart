import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData suffixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final Color backgroundColor;
  final TextStyle? hintStyle;
  const CustomTextField(
      {super.key,
      required this.label,
      required this.hint,
      required this.suffixIcon,
      required this.controller,
      this.isPassword = false,
      this.backgroundColor = AppColors.buttonText,
      this.hintStyle});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.label,
              textAlign: TextAlign.right,
              style: AppTextStyles.label,
            ),
          ),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscure : false,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: widget.hintStyle ?? AppTextStyles.hint,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.grey,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : Icon(widget.suffixIcon, color: AppColors.grey, size: 20),
            filled: true,
            fillColor: widget.backgroundColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
