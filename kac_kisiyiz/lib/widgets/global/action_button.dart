import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

class ActionButton extends StatefulWidget {
  const ActionButton(
      {super.key, this.onPressed, required this.text, this.outlined = false});
  const ActionButton.outlined({super.key, this.onPressed, required this.text})
      : outlined = true;

  final Function()? onPressed;
  final String text;
  final bool outlined;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    final rippleColor = widget.outlined ? Colors.grey.shade200 : Colors.white24;
    final borderRadius = BorderRadius.circular(kBorderRadius);
    return Material(
      elevation: 2.0,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: widget.onPressed,
        splashColor: rippleColor,
        highlightColor: rippleColor,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: widget.outlined ? Colors.white : KColors.primary,
            borderRadius: borderRadius,
            border: widget.outlined
                ? Border.all(color: KColors.disabled, width: 2)
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.outlined ? Colors.black87 : Colors.white,
              fontSize: kFontSizeButton + 2,
              letterSpacing: kLetterSpacing,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
