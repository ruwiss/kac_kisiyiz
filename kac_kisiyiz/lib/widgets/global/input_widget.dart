import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({super.key, this.controller, required this.hintText});
  final TextEditingController? controller;
  final String hintText;

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: _focusNode.hasFocus ? KColors.primary : KColors.border,
            width: kBorderWidth),
        boxShadow: !_focusNode.hasFocus
            ? null
            : [
                BoxShadow(
                  color: KColors.primary.withOpacity(.2),
                  blurRadius: 4,
                  offset: const Offset(3, 4), // Shadow position
                ),
              ],
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        style: const TextStyle(
          fontSize: kFontSizeButton,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: kFontSizeButton,
            fontWeight: FontWeight.w500,
            color: KColors.disabled,
          ),
        ),
      ),
    );
  }
}
