import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_container.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText = false,
    this.isMultiline = false,
    this.minLines = 1,
    this.validator,
    this.isDisabled = false,
    this.icon,
    this.iconClicked,
  });
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final bool isMultiline;
  final int minLines;
  final String? Function(String?)? validator;
  final bool isDisabled;
  final IconData? icon;
  final Function()? iconClicked;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
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
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        InputContainer(
          focus: _focusNode.hasFocus,
          child: TextFormField(
            enabled: !widget.isDisabled,
            validator: widget.validator,
            focusNode: _focusNode,
            controller: widget.controller,
            style: const TextStyle(
              fontSize: kFontSizeButton,
              fontWeight: FontWeight.w500,
            ),
            minLines: widget.minLines,
            maxLines: widget.isMultiline ? 5 : 1,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              errorStyle: const TextStyle(
                  color: KColors.primary, fontWeight: FontWeight.w500),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: kFontSizeButton,
                fontWeight: FontWeight.w500,
                color: KColors.disabled,
              ),
            ),
          ),
        ),
        if (widget.icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                widget.icon,
                size: 28,
                color: KColors.primary,
              ),
              onPressed: widget.iconClicked,
            ),
          ),
      ],
    );
  }
}
