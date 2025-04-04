import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final InputDecoration? inputDecoration;

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
      this.maxLength,
      this.inputDecoration});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType ?? TextInputType.number,
      cursorColor: appColors.appColor,
      onSubmitted: onSubmitted,
      inputFormatters:
          numFormater ?? [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
      maxLength: maxLength,
      style: typo.get14.w400,
      autofocus: autofocus,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: inputDecoration ??
          InputDecoration(
            counterText: "",
            filled: true,
            hintText: hintText,
            prefixIcon: prefix,
          ),
      controller: controller,
    );
  }
}
