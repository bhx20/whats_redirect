import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:redirect/app/core/app_typography.dart';

class AppTextField extends StatelessWidget {
  final String? errorText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final bool autofocus;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? numFormater;
  final int? maxLength;

  const AppTextField(
      {super.key,
      this.errorText,
      this.hintText = "",
      this.controller,
      this.keyboardType,
      this.prefix,
      this.onSubmitted,
      this.autofocus = false,
      this.focusNode,
      this.onChanged,
      this.numFormater,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType ?? TextInputType.number,
      cursorColor: const Color(0xff1daa61),
      onSubmitted: onSubmitted,
      inputFormatters: numFormater ?? [FilteringTextInputFormatter.digitsOnly],
      maxLength: maxLength,
      style: typo.get14.w400,
      autofocus: autofocus,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        filled: true,
        fillColor: AppColors.xfff6f5f3,
        hintText: hintText,
        prefixIcon: prefix,
        hintStyle: TextStyle(color: AppColors.xff7b7a78),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDCD6D6), width: 0.15),
            borderRadius: BorderRadius.all(Radius.circular(100))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDCD6D6), width: 0.15),
            borderRadius: BorderRadius.all(Radius.circular(100))),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDCD6D6), width: 0.15),
            borderRadius: BorderRadius.all(Radius.circular(100))),
      ),
      controller: controller,
    );
  }
}
