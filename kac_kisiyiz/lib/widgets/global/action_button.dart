import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.text,
    this.padding,
    this.textStyle,
    this.margin,
    this.elevation = 2.0,
    this.backgroundColor = KColors.primary,
    this.borderColor,
    this.rippleColor = Colors.white24,
    this.textColor = Colors.white,
  });

  ActionButton.outlined({
    super.key,
    this.onPressed,
    required this.text,
    this.padding,
    this.textStyle,
    this.margin,
  })  : elevation = 2.0,
        backgroundColor = Colors.white,
        borderColor = KColors.disabled.withOpacity(.3),
        rippleColor = KColors.rippleOutlinedColor,
        textColor = Colors.black87;

  final Function()? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? rippleColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final TextStyle? textStyle;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(kBorderRadius);
    return Container(
      margin: widget.margin,
      child: Material(
        elevation: widget.elevation,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: widget.onPressed,
          splashColor: widget.rippleColor,
          highlightColor: widget.rippleColor,
          borderRadius: borderRadius,
          child: Ink(
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: borderRadius,
                border: widget.borderColor == null
                    ? null
                    : Border.all(color: widget.borderColor!, width: 2)),
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: widget.textStyle ??
                  TextStyle(
                    color: widget.textColor,
                    fontSize: kFontSizeButton + 2,
                    letterSpacing: kLetterSpacing,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
