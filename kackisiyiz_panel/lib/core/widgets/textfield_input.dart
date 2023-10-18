import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/extensions/context_extensions.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool multiLine;
  final bool obscured;
  final bool dontValidate;
  final Widget? suffix;
  final Widget? suffixIcon;

  const TextFieldInput({
    super.key,
    this.controller,
    this.hint,
    this.multiLine = false,
    this.obscured = false,
    this.dontValidate = false,
    this.suffix,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty && !dontValidate) {
            return "Boş bırakmayınız";
          }
          return null;
        },
        obscureText: obscured,
        controller: controller,
        maxLines: multiLine ? 5 : 1,
        decoration: InputDecoration(
          suffix: suffix,
          suffixIcon: suffix == null ? null : Padding(padding: const EdgeInsets.only(right: 10), child: suffixIcon),
          filled: true,
          fillColor: context.secondaryColor,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: multiLine ? 15 : 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
