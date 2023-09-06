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
  bool _tapAnimation = false;

  void _setTapAnimation(bool val) => setState(() => _tapAnimation = val);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onTapDown: (_) => _setTapAnimation(true),
      onTapUp: (_) => _setTapAnimation(false),
      onTapCancel: () => _setTapAnimation(false),
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.outlined ? Colors.white : KColors.primary,
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: widget.outlined
              ? Border.all(color: KColors.disabled, width: 2)
              : null,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(3, 4), // Shadow position
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(
          widget.text,
          style: TextStyle(
              color: widget.outlined ? Colors.black87 : Colors.white,
              fontSize:
                  _tapAnimation ? kFontSizeButton + 1.5 : kFontSizeButton + 2,
              letterSpacing: kLetterSpacing,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
